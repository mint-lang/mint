#include "tree_sitter/parser.h"

#include <stdbool.h>

#include <stdint.h>

enum TokenType {
  STRING_CONTENT,
  JS_CONTENT,
  CSS_VALUE_CONTENT,
  HERE_DOCUMENT_CONTENT,
  HTML_OPEN,
  CSS_SELECTOR_NAME,
};

void *tree_sitter_mint_external_scanner_create() { return NULL; }
void tree_sitter_mint_external_scanner_destroy(void *payload) {}
void tree_sitter_mint_external_scanner_reset(void *payload) {}

unsigned tree_sitter_mint_external_scanner_serialize(void *payload,
                                                     char *buffer) {
  return 0;
}

void tree_sitter_mint_external_scanner_deserialize(void *payload,
                                                   const char *buffer,
                                                   unsigned length) {}

static void advance(TSLexer *lexer) { lexer->advance(lexer, false); }
static void skip(TSLexer *lexer) { lexer->advance(lexer, true); }

static bool is_whitespace(int32_t c) {
  return c == ' ' || c == '\t' || c == '\r' || c == '\n';
}

// Scans raw content inside a string (`"..."`) or inlined JavaScript
// (`` `...` ``) up to the terminator, an interpolation (`#{`) or EOF.
// `terminator` is `"` for strings and `` ` `` for JavaScript.
static bool scan_raw_content(TSLexer *lexer, char terminator,
                             enum TokenType symbol) {
  lexer->result_symbol = symbol;

  bool has_content = false;

  while (true) {
    if (lexer->lookahead == terminator || lexer->lookahead == 0) {
      return has_content;
    }

    // A backslash escape is handled by a separate immediate token in the
    // grammar, so stop before it (only inside strings).
    if (lexer->lookahead == '\\' && terminator == '"') {
      return has_content;
    }

    // Stop before an interpolation start `#{`.
    if (lexer->lookahead == '#') {
      lexer->mark_end(lexer);
      advance(lexer);

      if (lexer->lookahead == '{') {
        return has_content;
      }

      has_content = true;
      continue;
    }

    advance(lexer);
    has_content = true;
    lexer->mark_end(lexer);
  }
}

// Scans the raw value of a CSS definition, terminated by `;`, `}`, `{` or
// EOF, while stopping before strings (`"`) and interpolations (`#{`) so they
// can be parsed as separate nodes.
static bool scan_css_value(TSLexer *lexer) {
  lexer->result_symbol = CSS_VALUE_CONTENT;

  // Leading whitespace is not part of the value.
  while (is_whitespace(lexer->lookahead)) {
    skip(lexer);
  }

  bool has_content = false;

  while (true) {
    int32_t c = lexer->lookahead;

    if (c == ';' || c == '}' || c == '{' || c == '"' || c == 0) {
      return has_content;
    }

    if (c == '#') {
      lexer->mark_end(lexer);
      advance(lexer);

      if (lexer->lookahead == '{') {
        return has_content;
      }

      has_content = true;
      continue;
    }

    advance(lexer);
    has_content = true;
    lexer->mark_end(lexer);
  }
}

// Scans the body of a here document. Content is consumed up to an
// interpolation (`#{`) or up to an uppercase identifier appearing at the
// start of a line, which is a potential closing token. The grammar matches
// the actual closing `constant` after this token.
static bool scan_here_document(TSLexer *lexer) {
  lexer->result_symbol = HERE_DOCUMENT_CONTENT;

  bool has_content = false;
  bool at_line_start = true;

  while (true) {
    int32_t c = lexer->lookahead;

    if (c == 0) {
      return has_content;
    }

    if (c == '#') {
      lexer->mark_end(lexer);
      advance(lexer);

      if (lexer->lookahead == '{') {
        return has_content;
      }

      has_content = true;
      at_line_start = false;
      continue;
    }

    // An uppercase letter at the start of a line may be the closing token.
    if (at_line_start && c >= 'A' && c <= 'Z') {
      return has_content;
    }

    if (c != ' ' && c != '\t' && c != '\r' && c != '\n') {
      at_line_start = false;
    } else if (c == '\n') {
      at_line_start = true;
    }

    advance(lexer);
    has_content = true;
    lexer->mark_end(lexer);
  }
}

// Scans the `<` that opens an HTML element, component or fragment. It only
// succeeds when the `<` is immediately followed (no whitespace) by a tag
// character: a letter or `>`. This keeps it distinct from the `<` operator,
// which is always written with surrounding whitespace.
static bool scan_html_open(TSLexer *lexer) {
  // Leading whitespace is not skipped automatically for external tokens.
  while (is_whitespace(lexer->lookahead)) {
    skip(lexer);
  }

  if (lexer->lookahead != '<') {
    return false;
  }

  advance(lexer);

  int32_t c = lexer->lookahead;
  bool is_tag_start =
      c == '>' || (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');

  if (!is_tag_start) {
    return false;
  }

  lexer->mark_end(lexer);
  lexer->result_symbol = HTML_OPEN;
  return true;
}

// Scans the text of a single CSS selector fragment, up to a `,` or `{`. It
// only succeeds if a `{` is reached before any `;` or `}`, which means the
// construct is a CSS selector rather than a `css_definition`. The consumed
// text is trimmed of trailing whitespace.
static bool scan_css_selector_name(TSLexer *lexer) {
  // Leading whitespace is not skipped automatically for external tokens.
  while (is_whitespace(lexer->lookahead)) {
    skip(lexer);
  }

  bool has_content = false;
  bool at_trailing_whitespace = false;

  while (true) {
    int32_t c = lexer->lookahead;

    if (c == ',' || c == '{') {
      // A `{` (or another selector after `,`) confirms a selector.
      return has_content;
    }

    if (c == ';' || c == '}' || c == 0) {
      // A `;`/`}` first means this is a definition or block end.
      return false;
    }

    // `#{...}` is an interpolation, not a selector — a definition value.
    if (c == '#') {
      advance(lexer);
      if (lexer->lookahead == '{') {
        return false;
      }
      has_content = true;
      lexer->mark_end(lexer);
      continue;
    }

    advance(lexer);

    if (!is_whitespace(c)) {
      has_content = true;
      // Mark the end after the last non-whitespace character so trailing
      // whitespace is excluded from the token.
      lexer->mark_end(lexer);
      at_trailing_whitespace = false;
    } else {
      at_trailing_whitespace = true;
    }

    (void)at_trailing_whitespace;
  }
}

bool tree_sitter_mint_external_scanner_scan(void *payload, TSLexer *lexer,
                                            const bool *valid_symbols) {
  if (valid_symbols[HTML_OPEN] && scan_html_open(lexer)) {
    return true;
  }

  if (valid_symbols[CSS_SELECTOR_NAME]) {
    lexer->result_symbol = CSS_SELECTOR_NAME;
    if (scan_css_selector_name(lexer)) {
      return true;
    }
  }

  if (valid_symbols[HERE_DOCUMENT_CONTENT]) {
    return scan_here_document(lexer);
  }

  if (valid_symbols[STRING_CONTENT]) {
    return scan_raw_content(lexer, '"', STRING_CONTENT);
  }

  if (valid_symbols[JS_CONTENT]) {
    return scan_raw_content(lexer, '`', JS_CONTENT);
  }

  if (valid_symbols[CSS_VALUE_CONTENT]) {
    return scan_css_value(lexer);
  }

  return false;
}
