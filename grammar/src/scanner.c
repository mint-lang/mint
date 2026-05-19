#include "tree_sitter/parser.h"

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

enum TokenType {
  STRING_CONTENT,
  JS_CONTENT,
  CSS_VALUE_CONTENT,
  HERE_DOCUMENT_TOKEN,
  HERE_DOCUMENT_CONTENT,
  HERE_DOCUMENT_END,
  HTML_OPEN,
  CSS_SELECTOR_NAME,
};

// The longest here-document terminator we track. A SCREAMING_CASE name
// longer than this still parses, just without the precise terminator match.
#define MAX_HEREDOC_TOKEN 64

// Scanner state: the terminator of the here document currently being
// scanned. `token_length == 0` means no here document is open.
typedef struct {
  char token[MAX_HEREDOC_TOKEN];
  unsigned token_length;
} Scanner;

void *tree_sitter_mint_external_scanner_create() {
  Scanner *scanner = calloc(1, sizeof(Scanner));
  return scanner;
}

void tree_sitter_mint_external_scanner_destroy(void *payload) {
  free(payload);
}

unsigned tree_sitter_mint_external_scanner_serialize(void *payload,
                                                     char *buffer) {
  Scanner *scanner = payload;
  unsigned length = scanner->token_length;
  buffer[0] = (char)length;
  memcpy(buffer + 1, scanner->token, length);
  return length + 1;
}

void tree_sitter_mint_external_scanner_deserialize(void *payload,
                                                   const char *buffer,
                                                   unsigned length) {
  Scanner *scanner = payload;
  if (length == 0) {
    scanner->token_length = 0;
    return;
  }
  scanner->token_length = (unsigned char)buffer[0];
  memcpy(scanner->token, buffer + 1, scanner->token_length);
}

static void advance(TSLexer *lexer) { lexer->advance(lexer, false); }
static void skip(TSLexer *lexer) { lexer->advance(lexer, true); }

static bool is_whitespace(int32_t c) {
  return c == ' ' || c == '\t' || c == '\r' || c == '\n';
}

static bool is_constant_char(int32_t c) {
  return (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_';
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

// Scans the SCREAMING_CASE terminator name right after `<<~`/`<<#`/`<<-`
// and stores it so the matching closing token can be found. Emitted as
// `HERE_DOCUMENT_TOKEN`.
static bool scan_here_document_token(Scanner *scanner, TSLexer *lexer) {
  if (!(lexer->lookahead >= 'A' && lexer->lookahead <= 'Z')) {
    return false;
  }

  unsigned length = 0;
  while (is_constant_char(lexer->lookahead)) {
    if (length < MAX_HEREDOC_TOKEN) {
      scanner->token[length] = (char)lexer->lookahead;
    }
    length++;
    advance(lexer);
  }

  if (length == 0 || length > MAX_HEREDOC_TOKEN) {
    return false;
  }

  scanner->token_length = length;
  lexer->mark_end(lexer);
  lexer->result_symbol = HERE_DOCUMENT_TOKEN;
  return true;
}

// Returns true if the input at the current position is exactly the stored
// here-document terminator followed by a non-constant character. Advances
// the lexer past every character it inspects (whether it matches or not),
// so `*consumed` reports the progress made — at least one character unless
// the terminator is empty.
static bool at_here_document_end(Scanner *scanner, TSLexer *lexer,
                                 unsigned *consumed) {
  *consumed = 0;
  for (unsigned i = 0; i < scanner->token_length; i++) {
    if (lexer->lookahead != (int32_t)scanner->token[i]) {
      return false;
    }
    advance(lexer);
    (*consumed)++;
  }
  return !is_constant_char(lexer->lookahead);
}

// Scans the body of a here document. Content runs up to — but not
// including — an interpolation (`#{`) or the stored terminator. It returns
// false (matching nothing, no advance) when positioned exactly at one of
// those, so the grammar's `repeat` never loops on a zero-width token.
//
// `lexer->mark_end` is called only after a confirmed content character, so
// the token always ends exactly after the last content byte even though
// the terminator check advances the lexer.
static bool scan_here_document_content(Scanner *scanner, TSLexer *lexer) {
  lexer->result_symbol = HERE_DOCUMENT_CONTENT;

  bool has_content = false;

  while (true) {
    int32_t c = lexer->lookahead;

    if (c == 0) {
      return has_content;
    }

    // An uppercase letter may begin the terminator. The check advances the
    // lexer by however many characters it inspected, so the content
    // boundary is fixed with `mark_end` beforehand.
    if (c >= 'A' && c <= 'Z') {
      lexer->mark_end(lexer);
      unsigned consumed = 0;
      if (at_here_document_end(scanner, lexer, &consumed)) {
        // At the terminator — stop. If no content was seen this is a
        // zero-width match, so report nothing.
        return has_content;
      }
      // Not the terminator. The check may have inspected zero characters
      // (first-character mismatch); consume at least this one to guarantee
      // forward progress.
      if (consumed == 0) {
        advance(lexer);
      }
      has_content = true;
      lexer->mark_end(lexer);
      continue;
    }

    // `#{` begins an interpolation; a lone `#` is content.
    if (c == '#') {
      lexer->mark_end(lexer);
      advance(lexer);
      if (lexer->lookahead == '{') {
        return has_content;
      }
      has_content = true;
      lexer->mark_end(lexer);
      continue;
    }

    advance(lexer);
    has_content = true;
    lexer->mark_end(lexer);
  }
}

// Matches the stored here-document terminator and clears the scanner state.
static bool scan_here_document_end(Scanner *scanner, TSLexer *lexer) {
  unsigned consumed = 0;
  if (!at_here_document_end(scanner, lexer, &consumed)) {
    return false;
  }
  lexer->mark_end(lexer);
  lexer->result_symbol = HERE_DOCUMENT_END;
  scanner->token_length = 0;
  return true;
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

// Scans the text of a single CSS selector fragment. A selector and a
// `css_definition` both start with text; they are told apart by what
// terminates them — a selector ends at `{`, a definition at `;`. This
// scanner emits the fragment only after confirming, by looking ahead, that
// the construct really is a selector: a top-level `{` is reached before any
// top-level `;`/`}`.
//
// The token itself covers just the first fragment (up to the first
// top-level `,` or `{`), since `css_selector` is a comma-separated list of
// `css_selector_name`s. Commas and semicolons inside parentheses — e.g.
// `hsl(195,100%,55%)` in a value — are ignored via paren-depth tracking.
#define MAX_LEAD_WORD 8

static bool is_identifier_char(int32_t c) {
  return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') ||
         (c >= '0' && c <= '9') || c == '_';
}

static bool str_eq(const char *buf, int len, const char *word) {
  for (int i = 0; i < len; i++) {
    if (word[i] == '\0' || buf[i] != word[i]) {
      return false;
    }
  }
  return word[len] == '\0';
}

static bool scan_css_selector_name(TSLexer *lexer) {
  // Leading whitespace is not skipped automatically for external tokens.
  while (is_whitespace(lexer->lookahead)) {
    skip(lexer);
  }

  bool has_content = false;
  bool fragment_ended = false;
  int paren_depth = 0;

  // Consume the leading identifier word (if any) so it can be checked
  // against the CSS-context keywords `if` and `case`, which have their own
  // rules and must not be parsed as a selector. The characters are kept in
  // the token if the word is not a keyword.
  {
    char word[MAX_LEAD_WORD];
    int len = 0;

    while (is_identifier_char(lexer->lookahead)) {
      if (len < MAX_LEAD_WORD) {
        word[len] = (char)lexer->lookahead;
      }
      len++;
      advance(lexer);
    }

    if (len <= MAX_LEAD_WORD &&
        (str_eq(word, len, "if") || str_eq(word, len, "case") ||
         str_eq(word, len, "else"))) {
      return false;
    }

    if (len > 0) {
      has_content = true;
      lexer->mark_end(lexer);
    }
  }

  while (true) {
    int32_t c = lexer->lookahead;

    if (c == 0) {
      return false;
    }

    if (paren_depth == 0) {
      if (c == '{') {
        // A top-level `{` confirms a selector. The token is the first
        // fragment, already delimited by `mark_end`.
        return has_content;
      }

      if (c == ';' || c == '}') {
        // A top-level `;`/`}` first means this is a definition or a block
        // end, not a selector.
        return false;
      }

      if (c == ',' && !fragment_ended) {
        // End of the first selector fragment. Keep scanning (without
        // extending the token) to confirm a `{` still follows.
        fragment_ended = true;
        advance(lexer);
        continue;
      }
    }

    // `#{...}` is an interpolation; a selector never contains one.
    if (c == '#') {
      advance(lexer);
      if (lexer->lookahead == '{') {
        return false;
      }
      if (!fragment_ended && !is_whitespace(c)) {
        has_content = true;
        lexer->mark_end(lexer);
      }
      continue;
    }

    if (c == '(') {
      paren_depth++;
    } else if (c == ')' && paren_depth > 0) {
      paren_depth--;
    }

    advance(lexer);

    // Extend the token only while still inside the first fragment, and mark
    // the end after the last non-whitespace character so trailing
    // whitespace is excluded.
    if (!fragment_ended && !is_whitespace(c)) {
      has_content = true;
      lexer->mark_end(lexer);
    }
  }
}

bool tree_sitter_mint_external_scanner_scan(void *payload, TSLexer *lexer,
                                            const bool *valid_symbols) {
  Scanner *scanner = payload;

  // Here-document end is checked first: it must win over content so the
  // body does not swallow the terminator.
  if (valid_symbols[HERE_DOCUMENT_END] && scanner->token_length > 0 &&
      scan_here_document_end(scanner, lexer)) {
    return true;
  }

  if (valid_symbols[HERE_DOCUMENT_CONTENT] && scanner->token_length > 0) {
    return scan_here_document_content(scanner, lexer);
  }

  if (valid_symbols[HERE_DOCUMENT_TOKEN] &&
      scan_here_document_token(scanner, lexer)) {
    return true;
  }

  if (valid_symbols[HTML_OPEN] && scan_html_open(lexer)) {
    return true;
  }

  if (valid_symbols[CSS_SELECTOR_NAME]) {
    lexer->result_symbol = CSS_SELECTOR_NAME;
    if (scan_css_selector_name(lexer)) {
      return true;
    }
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
