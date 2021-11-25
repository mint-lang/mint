#include <tree_sitter/parser.h>
#include <wctype.h>

enum TokenType {
  STRING_CHARS,
  JAVASCRIPT_CHARS
};

void *tree_sitter_mint_external_scanner_create() { return NULL; }
void tree_sitter_mint_external_scanner_destroy(void *p) {}
void tree_sitter_mint_external_scanner_reset(void *p) {}
unsigned tree_sitter_mint_external_scanner_serialize(void *p, char *buffer) { return 0; }
void tree_sitter_mint_external_scanner_deserialize(void *p, const char *b, unsigned n) {}

static void advance(TSLexer *lexer) { lexer->advance(lexer, false); }
static void skip(TSLexer *lexer) { lexer->advance(lexer, true); }

static bool scan_string_chars(TSLexer *lexer) {
  lexer->result_symbol = STRING_CHARS;

  for (bool has_content = false;; has_content = true) {
    lexer->mark_end(lexer);
    switch (lexer->lookahead) {
      case '"':
        return has_content;
      case '\0':
        return false;
      case '#':
        advance(lexer);
        if (lexer->lookahead == '{') return has_content;
        break;
      // case '\\':
      //   return has_content;
      default:
        advance(lexer);
    }
  }
}

static bool scan_javascript_chars(TSLexer *lexer) {
  lexer->result_symbol = JAVASCRIPT_CHARS;

  for (bool has_content = false;; has_content = true) {
    lexer->mark_end(lexer);
    switch (lexer->lookahead) {
      case '`':
        return has_content;
      case '\0':
        return false;
      case '#':
        advance(lexer);
        if (lexer->lookahead == '{') return has_content;
        break;
      // case '\\':
      //   return has_content;
      default:
        advance(lexer);
    }
  }
}

bool tree_sitter_mint_external_scanner_scan(void *payload, TSLexer *lexer,
                                                  const bool *valid_symbols) {
  if (valid_symbols[STRING_CHARS]) {
    return scan_string_chars(lexer);
  }

  if (valid_symbols[JAVASCRIPT_CHARS]) {
    return scan_javascript_chars(lexer);
  }

  return false;
}
