#include <tree_sitter/parser.h>

#if defined(__GNUC__) || defined(__clang__)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmissing-field-initializers"
#endif

#define LANGUAGE_VERSION 13
#define STATE_COUNT 70
#define LARGE_STATE_COUNT 2
#define SYMBOL_COUNT 33
#define ALIAS_COUNT 0
#define TOKEN_COUNT 16
#define EXTERNAL_TOKEN_COUNT 0
#define FIELD_COUNT 3
#define MAX_ALIAS_SEQUENCE_LENGTH 7
#define PRODUCTION_ID_COUNT 7

enum {
  sym_comment = 1,
  anon_sym_module = 2,
  anon_sym_LBRACE = 3,
  anon_sym_RBRACE = 4,
  anon_sym_fun = 5,
  anon_sym_LPAREN = 6,
  anon_sym_COMMA = 7,
  anon_sym_RPAREN = 8,
  sym_variable = 9,
  anon_sym_DOT = 10,
  sym__entity_part = 11,
  anon_sym_EQ = 12,
  anon_sym_BQUOTE = 13,
  aux_sym_inline_javascript_token1 = 14,
  anon_sym_COLON = 15,
  sym_program = 16,
  sym__top_level = 17,
  sym_module = 18,
  sym_function = 19,
  sym_argument_list = 20,
  sym_argument = 21,
  sym_entity_name = 22,
  sym_statement = 23,
  sym_inline_javascript = 24,
  sym_type_definition = 25,
  sym_type = 26,
  aux_sym_program_repeat1 = 27,
  aux_sym_module_repeat1 = 28,
  aux_sym_function_repeat1 = 29,
  aux_sym_argument_list_repeat1 = 30,
  aux_sym_entity_name_repeat1 = 31,
  aux_sym_type_repeat1 = 32,
};

static const char * const ts_symbol_names[] = {
  [ts_builtin_sym_end] = "end",
  [sym_comment] = "comment",
  [anon_sym_module] = "module",
  [anon_sym_LBRACE] = "{",
  [anon_sym_RBRACE] = "}",
  [anon_sym_fun] = "fun",
  [anon_sym_LPAREN] = "(",
  [anon_sym_COMMA] = ",",
  [anon_sym_RPAREN] = ")",
  [sym_variable] = "variable",
  [anon_sym_DOT] = ".",
  [sym__entity_part] = "_entity_part",
  [anon_sym_EQ] = "=",
  [anon_sym_BQUOTE] = "`",
  [aux_sym_inline_javascript_token1] = "inline_javascript_token1",
  [anon_sym_COLON] = ":",
  [sym_program] = "program",
  [sym__top_level] = "_top_level",
  [sym_module] = "module",
  [sym_function] = "function",
  [sym_argument_list] = "argument_list",
  [sym_argument] = "argument",
  [sym_entity_name] = "entity_name",
  [sym_statement] = "statement",
  [sym_inline_javascript] = "inline_javascript",
  [sym_type_definition] = "type_definition",
  [sym_type] = "type",
  [aux_sym_program_repeat1] = "program_repeat1",
  [aux_sym_module_repeat1] = "module_repeat1",
  [aux_sym_function_repeat1] = "function_repeat1",
  [aux_sym_argument_list_repeat1] = "argument_list_repeat1",
  [aux_sym_entity_name_repeat1] = "entity_name_repeat1",
  [aux_sym_type_repeat1] = "type_repeat1",
};

static const TSSymbol ts_symbol_map[] = {
  [ts_builtin_sym_end] = ts_builtin_sym_end,
  [sym_comment] = sym_comment,
  [anon_sym_module] = anon_sym_module,
  [anon_sym_LBRACE] = anon_sym_LBRACE,
  [anon_sym_RBRACE] = anon_sym_RBRACE,
  [anon_sym_fun] = anon_sym_fun,
  [anon_sym_LPAREN] = anon_sym_LPAREN,
  [anon_sym_COMMA] = anon_sym_COMMA,
  [anon_sym_RPAREN] = anon_sym_RPAREN,
  [sym_variable] = sym_variable,
  [anon_sym_DOT] = anon_sym_DOT,
  [sym__entity_part] = sym__entity_part,
  [anon_sym_EQ] = anon_sym_EQ,
  [anon_sym_BQUOTE] = anon_sym_BQUOTE,
  [aux_sym_inline_javascript_token1] = aux_sym_inline_javascript_token1,
  [anon_sym_COLON] = anon_sym_COLON,
  [sym_program] = sym_program,
  [sym__top_level] = sym__top_level,
  [sym_module] = sym_module,
  [sym_function] = sym_function,
  [sym_argument_list] = sym_argument_list,
  [sym_argument] = sym_argument,
  [sym_entity_name] = sym_entity_name,
  [sym_statement] = sym_statement,
  [sym_inline_javascript] = sym_inline_javascript,
  [sym_type_definition] = sym_type_definition,
  [sym_type] = sym_type,
  [aux_sym_program_repeat1] = aux_sym_program_repeat1,
  [aux_sym_module_repeat1] = aux_sym_module_repeat1,
  [aux_sym_function_repeat1] = aux_sym_function_repeat1,
  [aux_sym_argument_list_repeat1] = aux_sym_argument_list_repeat1,
  [aux_sym_entity_name_repeat1] = aux_sym_entity_name_repeat1,
  [aux_sym_type_repeat1] = aux_sym_type_repeat1,
};

static const TSSymbolMetadata ts_symbol_metadata[] = {
  [ts_builtin_sym_end] = {
    .visible = false,
    .named = true,
  },
  [sym_comment] = {
    .visible = true,
    .named = true,
  },
  [anon_sym_module] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_LBRACE] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_RBRACE] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_fun] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_LPAREN] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_COMMA] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_RPAREN] = {
    .visible = true,
    .named = false,
  },
  [sym_variable] = {
    .visible = true,
    .named = true,
  },
  [anon_sym_DOT] = {
    .visible = true,
    .named = false,
  },
  [sym__entity_part] = {
    .visible = false,
    .named = true,
  },
  [anon_sym_EQ] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_BQUOTE] = {
    .visible = true,
    .named = false,
  },
  [aux_sym_inline_javascript_token1] = {
    .visible = false,
    .named = false,
  },
  [anon_sym_COLON] = {
    .visible = true,
    .named = false,
  },
  [sym_program] = {
    .visible = true,
    .named = true,
  },
  [sym__top_level] = {
    .visible = false,
    .named = true,
  },
  [sym_module] = {
    .visible = true,
    .named = true,
  },
  [sym_function] = {
    .visible = true,
    .named = true,
  },
  [sym_argument_list] = {
    .visible = true,
    .named = true,
  },
  [sym_argument] = {
    .visible = true,
    .named = true,
  },
  [sym_entity_name] = {
    .visible = true,
    .named = true,
  },
  [sym_statement] = {
    .visible = true,
    .named = true,
  },
  [sym_inline_javascript] = {
    .visible = true,
    .named = true,
  },
  [sym_type_definition] = {
    .visible = true,
    .named = true,
  },
  [sym_type] = {
    .visible = true,
    .named = true,
  },
  [aux_sym_program_repeat1] = {
    .visible = false,
    .named = false,
  },
  [aux_sym_module_repeat1] = {
    .visible = false,
    .named = false,
  },
  [aux_sym_function_repeat1] = {
    .visible = false,
    .named = false,
  },
  [aux_sym_argument_list_repeat1] = {
    .visible = false,
    .named = false,
  },
  [aux_sym_entity_name_repeat1] = {
    .visible = false,
    .named = false,
  },
  [aux_sym_type_repeat1] = {
    .visible = false,
    .named = false,
  },
};

enum {
  field_arguments = 1,
  field_name = 2,
  field_type = 3,
};

static const char * const ts_field_names[] = {
  [0] = NULL,
  [field_arguments] = "arguments",
  [field_name] = "name",
  [field_type] = "type",
};

static const TSFieldMapSlice ts_field_map_slices[PRODUCTION_ID_COUNT] = {
  [1] = {.index = 0, .length = 1},
  [2] = {.index = 1, .length = 1},
  [3] = {.index = 2, .length = 2},
  [4] = {.index = 4, .length = 2},
  [5] = {.index = 6, .length = 2},
  [6] = {.index = 8, .length = 3},
};

static const TSFieldMapEntry ts_field_map_entries[] = {
  [0] =
    {field_name, 1},
  [1] =
    {field_name, 0},
  [2] =
    {field_name, 0},
    {field_type, 1},
  [4] =
    {field_arguments, 2},
    {field_name, 1},
  [6] =
    {field_name, 1},
    {field_type, 2},
  [8] =
    {field_arguments, 2},
    {field_name, 1},
    {field_type, 3},
};

static const TSSymbol ts_alias_sequences[PRODUCTION_ID_COUNT][MAX_ALIAS_SEQUENCE_LENGTH] = {
  [0] = {0},
};

static const uint16_t ts_non_terminal_alias_map[] = {
  0,
};

static bool ts_lex(TSLexer *lexer, TSStateId state) {
  START_LEXER();
  eof = lexer->eof(lexer);
  switch (state) {
    case 0:
      if (eof) ADVANCE(13);
      if (lookahead == '(') ADVANCE(20);
      if (lookahead == ')') ADVANCE(22);
      if (lookahead == ',') ADVANCE(21);
      if (lookahead == '.') ADVANCE(24);
      if (lookahead == '/') ADVANCE(2);
      if (lookahead == ':') ADVANCE(30);
      if (lookahead == '=') ADVANCE(26);
      if (lookahead == '`') ADVANCE(27);
      if (lookahead == 'f') ADVANCE(10);
      if (lookahead == 'm') ADVANCE(9);
      if (lookahead == '{') ADVANCE(17);
      if (lookahead == '}') ADVANCE(18);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ') SKIP(0)
      if (('A' <= lookahead && lookahead <= 'Z')) ADVANCE(12);
      END_STATE();
    case 1:
      if (lookahead == ')') ADVANCE(22);
      if (lookahead == '`') ADVANCE(27);
      if (lookahead == '}') ADVANCE(18);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ') SKIP(1)
      if (('A' <= lookahead && lookahead <= 'Z')) ADVANCE(12);
      if (('a' <= lookahead && lookahead <= 'z')) ADVANCE(23);
      END_STATE();
    case 2:
      if (lookahead == '*') ADVANCE(4);
      if (lookahead == '/') ADVANCE(15);
      END_STATE();
    case 3:
      if (lookahead == '*') ADVANCE(3);
      if (lookahead == '/') ADVANCE(14);
      if (lookahead != 0) ADVANCE(4);
      END_STATE();
    case 4:
      if (lookahead == '*') ADVANCE(3);
      if (lookahead != 0) ADVANCE(4);
      END_STATE();
    case 5:
      if (lookahead == 'd') ADVANCE(11);
      END_STATE();
    case 6:
      if (lookahead == 'e') ADVANCE(16);
      END_STATE();
    case 7:
      if (lookahead == 'l') ADVANCE(6);
      END_STATE();
    case 8:
      if (lookahead == 'n') ADVANCE(19);
      END_STATE();
    case 9:
      if (lookahead == 'o') ADVANCE(5);
      END_STATE();
    case 10:
      if (lookahead == 'u') ADVANCE(8);
      END_STATE();
    case 11:
      if (lookahead == 'u') ADVANCE(7);
      END_STATE();
    case 12:
      if (('A' <= lookahead && lookahead <= 'Z') ||
          ('a' <= lookahead && lookahead <= 'z')) ADVANCE(25);
      END_STATE();
    case 13:
      ACCEPT_TOKEN(ts_builtin_sym_end);
      END_STATE();
    case 14:
      ACCEPT_TOKEN(sym_comment);
      END_STATE();
    case 15:
      ACCEPT_TOKEN(sym_comment);
      if (lookahead != 0 &&
          lookahead != '\n') ADVANCE(15);
      END_STATE();
    case 16:
      ACCEPT_TOKEN(anon_sym_module);
      END_STATE();
    case 17:
      ACCEPT_TOKEN(anon_sym_LBRACE);
      END_STATE();
    case 18:
      ACCEPT_TOKEN(anon_sym_RBRACE);
      END_STATE();
    case 19:
      ACCEPT_TOKEN(anon_sym_fun);
      END_STATE();
    case 20:
      ACCEPT_TOKEN(anon_sym_LPAREN);
      END_STATE();
    case 21:
      ACCEPT_TOKEN(anon_sym_COMMA);
      END_STATE();
    case 22:
      ACCEPT_TOKEN(anon_sym_RPAREN);
      END_STATE();
    case 23:
      ACCEPT_TOKEN(sym_variable);
      if (('0' <= lookahead && lookahead <= '9') ||
          ('A' <= lookahead && lookahead <= 'Z') ||
          ('a' <= lookahead && lookahead <= 'z')) ADVANCE(23);
      END_STATE();
    case 24:
      ACCEPT_TOKEN(anon_sym_DOT);
      END_STATE();
    case 25:
      ACCEPT_TOKEN(sym__entity_part);
      if (('A' <= lookahead && lookahead <= 'Z') ||
          ('a' <= lookahead && lookahead <= 'z')) ADVANCE(25);
      END_STATE();
    case 26:
      ACCEPT_TOKEN(anon_sym_EQ);
      END_STATE();
    case 27:
      ACCEPT_TOKEN(anon_sym_BQUOTE);
      END_STATE();
    case 28:
      ACCEPT_TOKEN(aux_sym_inline_javascript_token1);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ') ADVANCE(28);
      if (lookahead != 0 &&
          lookahead != '`') ADVANCE(29);
      END_STATE();
    case 29:
      ACCEPT_TOKEN(aux_sym_inline_javascript_token1);
      if (lookahead != 0 &&
          lookahead != '`') ADVANCE(29);
      END_STATE();
    case 30:
      ACCEPT_TOKEN(anon_sym_COLON);
      END_STATE();
    default:
      return false;
  }
}

static const TSLexMode ts_lex_modes[STATE_COUNT] = {
  [0] = {.lex_state = 0},
  [1] = {.lex_state = 0},
  [2] = {.lex_state = 1},
  [3] = {.lex_state = 1},
  [4] = {.lex_state = 1},
  [5] = {.lex_state = 0},
  [6] = {.lex_state = 1},
  [7] = {.lex_state = 1},
  [8] = {.lex_state = 0},
  [9] = {.lex_state = 1},
  [10] = {.lex_state = 1},
  [11] = {.lex_state = 1},
  [12] = {.lex_state = 1},
  [13] = {.lex_state = 0},
  [14] = {.lex_state = 0},
  [15] = {.lex_state = 0},
  [16] = {.lex_state = 0},
  [17] = {.lex_state = 0},
  [18] = {.lex_state = 0},
  [19] = {.lex_state = 1},
  [20] = {.lex_state = 0},
  [21] = {.lex_state = 0},
  [22] = {.lex_state = 1},
  [23] = {.lex_state = 1},
  [24] = {.lex_state = 0},
  [25] = {.lex_state = 0},
  [26] = {.lex_state = 0},
  [27] = {.lex_state = 0},
  [28] = {.lex_state = 0},
  [29] = {.lex_state = 1},
  [30] = {.lex_state = 0},
  [31] = {.lex_state = 0},
  [32] = {.lex_state = 0},
  [33] = {.lex_state = 1},
  [34] = {.lex_state = 0},
  [35] = {.lex_state = 0},
  [36] = {.lex_state = 0},
  [37] = {.lex_state = 0},
  [38] = {.lex_state = 0},
  [39] = {.lex_state = 0},
  [40] = {.lex_state = 0},
  [41] = {.lex_state = 0},
  [42] = {.lex_state = 0},
  [43] = {.lex_state = 1},
  [44] = {.lex_state = 0},
  [45] = {.lex_state = 0},
  [46] = {.lex_state = 0},
  [47] = {.lex_state = 0},
  [48] = {.lex_state = 1},
  [49] = {.lex_state = 0},
  [50] = {.lex_state = 0},
  [51] = {.lex_state = 1},
  [52] = {.lex_state = 0},
  [53] = {.lex_state = 0},
  [54] = {.lex_state = 0},
  [55] = {.lex_state = 0},
  [56] = {.lex_state = 0},
  [57] = {.lex_state = 0},
  [58] = {.lex_state = 0},
  [59] = {.lex_state = 0},
  [60] = {.lex_state = 0},
  [61] = {.lex_state = 0},
  [62] = {.lex_state = 0},
  [63] = {.lex_state = 0},
  [64] = {.lex_state = 0},
  [65] = {.lex_state = 0},
  [66] = {.lex_state = 1},
  [67] = {.lex_state = 28},
  [68] = {.lex_state = 0},
  [69] = {.lex_state = 0},
};

static const uint16_t ts_parse_table[LARGE_STATE_COUNT][SYMBOL_COUNT] = {
  [0] = {
    [ts_builtin_sym_end] = ACTIONS(1),
    [sym_comment] = ACTIONS(1),
    [anon_sym_module] = ACTIONS(1),
    [anon_sym_LBRACE] = ACTIONS(1),
    [anon_sym_RBRACE] = ACTIONS(1),
    [anon_sym_fun] = ACTIONS(1),
    [anon_sym_LPAREN] = ACTIONS(1),
    [anon_sym_COMMA] = ACTIONS(1),
    [anon_sym_RPAREN] = ACTIONS(1),
    [anon_sym_DOT] = ACTIONS(1),
    [sym__entity_part] = ACTIONS(1),
    [anon_sym_EQ] = ACTIONS(1),
    [anon_sym_BQUOTE] = ACTIONS(1),
    [anon_sym_COLON] = ACTIONS(1),
  },
  [1] = {
    [sym_program] = STATE(65),
    [sym__top_level] = STATE(5),
    [sym_module] = STATE(5),
    [aux_sym_program_repeat1] = STATE(5),
    [ts_builtin_sym_end] = ACTIONS(3),
    [sym_comment] = ACTIONS(5),
    [anon_sym_module] = ACTIONS(7),
  },
};

static const uint16_t ts_small_parse_table[] = {
  [0] = 5,
    ACTIONS(9), 1,
      anon_sym_RBRACE,
    ACTIONS(11), 1,
      sym_variable,
    ACTIONS(13), 1,
      anon_sym_BQUOTE,
    STATE(29), 1,
      sym_inline_javascript,
    STATE(9), 2,
      sym_statement,
      aux_sym_function_repeat1,
  [17] = 5,
    ACTIONS(11), 1,
      sym_variable,
    ACTIONS(13), 1,
      anon_sym_BQUOTE,
    ACTIONS(15), 1,
      anon_sym_RBRACE,
    STATE(29), 1,
      sym_inline_javascript,
    STATE(9), 2,
      sym_statement,
      aux_sym_function_repeat1,
  [34] = 5,
    ACTIONS(11), 1,
      sym_variable,
    ACTIONS(13), 1,
      anon_sym_BQUOTE,
    ACTIONS(17), 1,
      anon_sym_RBRACE,
    STATE(29), 1,
      sym_inline_javascript,
    STATE(9), 2,
      sym_statement,
      aux_sym_function_repeat1,
  [51] = 4,
    ACTIONS(7), 1,
      anon_sym_module,
    ACTIONS(19), 1,
      ts_builtin_sym_end,
    ACTIONS(21), 1,
      sym_comment,
    STATE(8), 3,
      sym__top_level,
      sym_module,
      aux_sym_program_repeat1,
  [66] = 5,
    ACTIONS(11), 1,
      sym_variable,
    ACTIONS(13), 1,
      anon_sym_BQUOTE,
    ACTIONS(23), 1,
      anon_sym_RBRACE,
    STATE(29), 1,
      sym_inline_javascript,
    STATE(3), 2,
      sym_statement,
      aux_sym_function_repeat1,
  [83] = 5,
    ACTIONS(11), 1,
      sym_variable,
    ACTIONS(13), 1,
      anon_sym_BQUOTE,
    ACTIONS(25), 1,
      anon_sym_RBRACE,
    STATE(29), 1,
      sym_inline_javascript,
    STATE(9), 2,
      sym_statement,
      aux_sym_function_repeat1,
  [100] = 4,
    ACTIONS(27), 1,
      ts_builtin_sym_end,
    ACTIONS(29), 1,
      sym_comment,
    ACTIONS(32), 1,
      anon_sym_module,
    STATE(8), 3,
      sym__top_level,
      sym_module,
      aux_sym_program_repeat1,
  [115] = 5,
    ACTIONS(35), 1,
      anon_sym_RBRACE,
    ACTIONS(37), 1,
      sym_variable,
    ACTIONS(40), 1,
      anon_sym_BQUOTE,
    STATE(29), 1,
      sym_inline_javascript,
    STATE(9), 2,
      sym_statement,
      aux_sym_function_repeat1,
  [132] = 5,
    ACTIONS(11), 1,
      sym_variable,
    ACTIONS(13), 1,
      anon_sym_BQUOTE,
    ACTIONS(43), 1,
      anon_sym_RBRACE,
    STATE(29), 1,
      sym_inline_javascript,
    STATE(4), 2,
      sym_statement,
      aux_sym_function_repeat1,
  [149] = 5,
    ACTIONS(11), 1,
      sym_variable,
    ACTIONS(13), 1,
      anon_sym_BQUOTE,
    ACTIONS(45), 1,
      anon_sym_RBRACE,
    STATE(29), 1,
      sym_inline_javascript,
    STATE(7), 2,
      sym_statement,
      aux_sym_function_repeat1,
  [166] = 5,
    ACTIONS(11), 1,
      sym_variable,
    ACTIONS(13), 1,
      anon_sym_BQUOTE,
    ACTIONS(47), 1,
      anon_sym_RBRACE,
    STATE(29), 1,
      sym_inline_javascript,
    STATE(2), 2,
      sym_statement,
      aux_sym_function_repeat1,
  [183] = 4,
    ACTIONS(49), 1,
      sym_comment,
    ACTIONS(51), 1,
      anon_sym_RBRACE,
    ACTIONS(53), 1,
      anon_sym_fun,
    STATE(15), 2,
      sym_function,
      aux_sym_module_repeat1,
  [197] = 4,
    ACTIONS(55), 1,
      sym_comment,
    ACTIONS(58), 1,
      anon_sym_RBRACE,
    ACTIONS(60), 1,
      anon_sym_fun,
    STATE(14), 2,
      sym_function,
      aux_sym_module_repeat1,
  [211] = 4,
    ACTIONS(53), 1,
      anon_sym_fun,
    ACTIONS(63), 1,
      sym_comment,
    ACTIONS(65), 1,
      anon_sym_RBRACE,
    STATE(14), 2,
      sym_function,
      aux_sym_module_repeat1,
  [225] = 5,
    ACTIONS(67), 1,
      anon_sym_LBRACE,
    ACTIONS(69), 1,
      anon_sym_LPAREN,
    ACTIONS(71), 1,
      anon_sym_COLON,
    STATE(44), 1,
      sym_argument_list,
    STATE(69), 1,
      sym_type_definition,
  [241] = 2,
    ACTIONS(75), 1,
      anon_sym_LPAREN,
    ACTIONS(73), 3,
      anon_sym_LBRACE,
      anon_sym_COMMA,
      anon_sym_RPAREN,
  [250] = 3,
    ACTIONS(71), 1,
      anon_sym_COLON,
    STATE(54), 1,
      sym_type_definition,
    ACTIONS(77), 2,
      anon_sym_COMMA,
      anon_sym_RPAREN,
  [261] = 4,
    ACTIONS(79), 1,
      anon_sym_RPAREN,
    ACTIONS(81), 1,
      sym_variable,
    ACTIONS(83), 1,
      sym__entity_part,
    STATE(38), 1,
      sym_type,
  [274] = 1,
    ACTIONS(85), 3,
      anon_sym_LBRACE,
      anon_sym_COMMA,
      anon_sym_RPAREN,
  [280] = 1,
    ACTIONS(87), 3,
      ts_builtin_sym_end,
      sym_comment,
      anon_sym_module,
  [286] = 3,
    ACTIONS(89), 1,
      anon_sym_RPAREN,
    ACTIONS(91), 1,
      sym_variable,
    STATE(31), 1,
      sym_argument,
  [296] = 3,
    ACTIONS(81), 1,
      sym_variable,
    ACTIONS(83), 1,
      sym__entity_part,
    STATE(46), 1,
      sym_type,
  [306] = 3,
    ACTIONS(93), 1,
      anon_sym_COMMA,
    ACTIONS(96), 1,
      anon_sym_RPAREN,
    STATE(24), 1,
      aux_sym_type_repeat1,
  [316] = 1,
    ACTIONS(98), 3,
      anon_sym_LBRACE,
      anon_sym_COMMA,
      anon_sym_RPAREN,
  [322] = 1,
    ACTIONS(100), 3,
      sym_comment,
      anon_sym_RBRACE,
      anon_sym_fun,
  [328] = 1,
    ACTIONS(102), 3,
      sym_comment,
      anon_sym_RBRACE,
      anon_sym_fun,
  [334] = 3,
    ACTIONS(104), 1,
      anon_sym_COMMA,
    ACTIONS(106), 1,
      anon_sym_RPAREN,
    STATE(24), 1,
      aux_sym_type_repeat1,
  [344] = 1,
    ACTIONS(108), 3,
      anon_sym_RBRACE,
      sym_variable,
      anon_sym_BQUOTE,
  [350] = 1,
    ACTIONS(110), 3,
      anon_sym_LBRACE,
      anon_sym_COMMA,
      anon_sym_RPAREN,
  [356] = 3,
    ACTIONS(112), 1,
      anon_sym_COMMA,
    ACTIONS(114), 1,
      anon_sym_RPAREN,
    STATE(34), 1,
      aux_sym_argument_list_repeat1,
  [366] = 1,
    ACTIONS(73), 3,
      anon_sym_LBRACE,
      anon_sym_COMMA,
      anon_sym_RPAREN,
  [372] = 3,
    ACTIONS(81), 1,
      sym_variable,
    ACTIONS(83), 1,
      sym__entity_part,
    STATE(59), 1,
      sym_type,
  [382] = 3,
    ACTIONS(112), 1,
      anon_sym_COMMA,
    ACTIONS(116), 1,
      anon_sym_RPAREN,
    STATE(42), 1,
      aux_sym_argument_list_repeat1,
  [392] = 3,
    ACTIONS(118), 1,
      anon_sym_LBRACE,
    ACTIONS(120), 1,
      anon_sym_DOT,
    STATE(35), 1,
      aux_sym_entity_name_repeat1,
  [402] = 1,
    ACTIONS(123), 3,
      sym_comment,
      anon_sym_RBRACE,
      anon_sym_fun,
  [408] = 1,
    ACTIONS(125), 3,
      sym_comment,
      anon_sym_RBRACE,
      anon_sym_fun,
  [414] = 3,
    ACTIONS(104), 1,
      anon_sym_COMMA,
    ACTIONS(127), 1,
      anon_sym_RPAREN,
    STATE(28), 1,
      aux_sym_type_repeat1,
  [424] = 1,
    ACTIONS(129), 3,
      ts_builtin_sym_end,
      sym_comment,
      anon_sym_module,
  [430] = 1,
    ACTIONS(131), 3,
      sym_comment,
      anon_sym_RBRACE,
      anon_sym_fun,
  [436] = 3,
    ACTIONS(133), 1,
      anon_sym_LBRACE,
    ACTIONS(135), 1,
      anon_sym_DOT,
    STATE(35), 1,
      aux_sym_entity_name_repeat1,
  [446] = 3,
    ACTIONS(137), 1,
      anon_sym_COMMA,
    ACTIONS(140), 1,
      anon_sym_RPAREN,
    STATE(42), 1,
      aux_sym_argument_list_repeat1,
  [456] = 1,
    ACTIONS(142), 3,
      anon_sym_RBRACE,
      sym_variable,
      anon_sym_BQUOTE,
  [462] = 3,
    ACTIONS(71), 1,
      anon_sym_COLON,
    ACTIONS(144), 1,
      anon_sym_LBRACE,
    STATE(64), 1,
      sym_type_definition,
  [472] = 1,
    ACTIONS(146), 3,
      sym_comment,
      anon_sym_RBRACE,
      anon_sym_fun,
  [478] = 1,
    ACTIONS(148), 3,
      anon_sym_LBRACE,
      anon_sym_COMMA,
      anon_sym_RPAREN,
  [484] = 1,
    ACTIONS(150), 3,
      sym_comment,
      anon_sym_RBRACE,
      anon_sym_fun,
  [490] = 1,
    ACTIONS(152), 3,
      anon_sym_RBRACE,
      sym_variable,
      anon_sym_BQUOTE,
  [496] = 3,
    ACTIONS(135), 1,
      anon_sym_DOT,
    ACTIONS(154), 1,
      anon_sym_LBRACE,
    STATE(41), 1,
      aux_sym_entity_name_repeat1,
  [506] = 1,
    ACTIONS(156), 3,
      sym_comment,
      anon_sym_RBRACE,
      anon_sym_fun,
  [512] = 2,
    ACTIONS(91), 1,
      sym_variable,
    STATE(52), 1,
      sym_argument,
  [519] = 1,
    ACTIONS(140), 2,
      anon_sym_COMMA,
      anon_sym_RPAREN,
  [524] = 1,
    ACTIONS(158), 2,
      anon_sym_LBRACE,
      anon_sym_COLON,
  [529] = 1,
    ACTIONS(160), 2,
      anon_sym_COMMA,
      anon_sym_RPAREN,
  [534] = 2,
    ACTIONS(13), 1,
      anon_sym_BQUOTE,
    STATE(48), 1,
      sym_inline_javascript,
  [541] = 1,
    ACTIONS(118), 2,
      anon_sym_LBRACE,
      anon_sym_DOT,
  [546] = 2,
    ACTIONS(162), 1,
      sym__entity_part,
    STATE(61), 1,
      sym_entity_name,
  [553] = 1,
    ACTIONS(164), 2,
      anon_sym_LBRACE,
      anon_sym_COLON,
  [558] = 1,
    ACTIONS(96), 2,
      anon_sym_COMMA,
      anon_sym_RPAREN,
  [563] = 1,
    ACTIONS(166), 2,
      anon_sym_LBRACE,
      anon_sym_COLON,
  [568] = 1,
    ACTIONS(168), 1,
      anon_sym_LBRACE,
  [572] = 1,
    ACTIONS(170), 1,
      sym__entity_part,
  [576] = 1,
    ACTIONS(172), 1,
      anon_sym_BQUOTE,
  [580] = 1,
    ACTIONS(174), 1,
      anon_sym_LBRACE,
  [584] = 1,
    ACTIONS(176), 1,
      ts_builtin_sym_end,
  [588] = 1,
    ACTIONS(178), 1,
      sym_variable,
  [592] = 1,
    ACTIONS(180), 1,
      aux_sym_inline_javascript_token1,
  [596] = 1,
    ACTIONS(182), 1,
      anon_sym_EQ,
  [600] = 1,
    ACTIONS(184), 1,
      anon_sym_LBRACE,
};

static const uint32_t ts_small_parse_table_map[] = {
  [SMALL_STATE(2)] = 0,
  [SMALL_STATE(3)] = 17,
  [SMALL_STATE(4)] = 34,
  [SMALL_STATE(5)] = 51,
  [SMALL_STATE(6)] = 66,
  [SMALL_STATE(7)] = 83,
  [SMALL_STATE(8)] = 100,
  [SMALL_STATE(9)] = 115,
  [SMALL_STATE(10)] = 132,
  [SMALL_STATE(11)] = 149,
  [SMALL_STATE(12)] = 166,
  [SMALL_STATE(13)] = 183,
  [SMALL_STATE(14)] = 197,
  [SMALL_STATE(15)] = 211,
  [SMALL_STATE(16)] = 225,
  [SMALL_STATE(17)] = 241,
  [SMALL_STATE(18)] = 250,
  [SMALL_STATE(19)] = 261,
  [SMALL_STATE(20)] = 274,
  [SMALL_STATE(21)] = 280,
  [SMALL_STATE(22)] = 286,
  [SMALL_STATE(23)] = 296,
  [SMALL_STATE(24)] = 306,
  [SMALL_STATE(25)] = 316,
  [SMALL_STATE(26)] = 322,
  [SMALL_STATE(27)] = 328,
  [SMALL_STATE(28)] = 334,
  [SMALL_STATE(29)] = 344,
  [SMALL_STATE(30)] = 350,
  [SMALL_STATE(31)] = 356,
  [SMALL_STATE(32)] = 366,
  [SMALL_STATE(33)] = 372,
  [SMALL_STATE(34)] = 382,
  [SMALL_STATE(35)] = 392,
  [SMALL_STATE(36)] = 402,
  [SMALL_STATE(37)] = 408,
  [SMALL_STATE(38)] = 414,
  [SMALL_STATE(39)] = 424,
  [SMALL_STATE(40)] = 430,
  [SMALL_STATE(41)] = 436,
  [SMALL_STATE(42)] = 446,
  [SMALL_STATE(43)] = 456,
  [SMALL_STATE(44)] = 462,
  [SMALL_STATE(45)] = 472,
  [SMALL_STATE(46)] = 478,
  [SMALL_STATE(47)] = 484,
  [SMALL_STATE(48)] = 490,
  [SMALL_STATE(49)] = 496,
  [SMALL_STATE(50)] = 506,
  [SMALL_STATE(51)] = 512,
  [SMALL_STATE(52)] = 519,
  [SMALL_STATE(53)] = 524,
  [SMALL_STATE(54)] = 529,
  [SMALL_STATE(55)] = 534,
  [SMALL_STATE(56)] = 541,
  [SMALL_STATE(57)] = 546,
  [SMALL_STATE(58)] = 553,
  [SMALL_STATE(59)] = 558,
  [SMALL_STATE(60)] = 563,
  [SMALL_STATE(61)] = 568,
  [SMALL_STATE(62)] = 572,
  [SMALL_STATE(63)] = 576,
  [SMALL_STATE(64)] = 580,
  [SMALL_STATE(65)] = 584,
  [SMALL_STATE(66)] = 588,
  [SMALL_STATE(67)] = 592,
  [SMALL_STATE(68)] = 596,
  [SMALL_STATE(69)] = 600,
};

static const TSParseActionEntry ts_parse_actions[] = {
  [0] = {.entry = {.count = 0, .reusable = false}},
  [1] = {.entry = {.count = 1, .reusable = false}}, RECOVER(),
  [3] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_program, 0),
  [5] = {.entry = {.count = 1, .reusable = true}}, SHIFT(5),
  [7] = {.entry = {.count = 1, .reusable = true}}, SHIFT(57),
  [9] = {.entry = {.count = 1, .reusable = true}}, SHIFT(40),
  [11] = {.entry = {.count = 1, .reusable = true}}, SHIFT(68),
  [13] = {.entry = {.count = 1, .reusable = true}}, SHIFT(67),
  [15] = {.entry = {.count = 1, .reusable = true}}, SHIFT(27),
  [17] = {.entry = {.count = 1, .reusable = true}}, SHIFT(45),
  [19] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_program, 1),
  [21] = {.entry = {.count = 1, .reusable = true}}, SHIFT(8),
  [23] = {.entry = {.count = 1, .reusable = true}}, SHIFT(36),
  [25] = {.entry = {.count = 1, .reusable = true}}, SHIFT(37),
  [27] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_program_repeat1, 2),
  [29] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_program_repeat1, 2), SHIFT_REPEAT(8),
  [32] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_program_repeat1, 2), SHIFT_REPEAT(57),
  [35] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_function_repeat1, 2),
  [37] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_function_repeat1, 2), SHIFT_REPEAT(68),
  [40] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_function_repeat1, 2), SHIFT_REPEAT(67),
  [43] = {.entry = {.count = 1, .reusable = true}}, SHIFT(50),
  [45] = {.entry = {.count = 1, .reusable = true}}, SHIFT(47),
  [47] = {.entry = {.count = 1, .reusable = true}}, SHIFT(26),
  [49] = {.entry = {.count = 1, .reusable = true}}, SHIFT(15),
  [51] = {.entry = {.count = 1, .reusable = true}}, SHIFT(21),
  [53] = {.entry = {.count = 1, .reusable = true}}, SHIFT(66),
  [55] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_module_repeat1, 2), SHIFT_REPEAT(14),
  [58] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_module_repeat1, 2),
  [60] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_module_repeat1, 2), SHIFT_REPEAT(66),
  [63] = {.entry = {.count = 1, .reusable = true}}, SHIFT(14),
  [65] = {.entry = {.count = 1, .reusable = true}}, SHIFT(39),
  [67] = {.entry = {.count = 1, .reusable = true}}, SHIFT(12),
  [69] = {.entry = {.count = 1, .reusable = true}}, SHIFT(22),
  [71] = {.entry = {.count = 1, .reusable = true}}, SHIFT(23),
  [73] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_type, 1),
  [75] = {.entry = {.count = 1, .reusable = true}}, SHIFT(19),
  [77] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_argument, 1, .production_id = 2),
  [79] = {.entry = {.count = 1, .reusable = true}}, SHIFT(20),
  [81] = {.entry = {.count = 1, .reusable = true}}, SHIFT(32),
  [83] = {.entry = {.count = 1, .reusable = true}}, SHIFT(17),
  [85] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_type, 3),
  [87] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_module, 4, .production_id = 1),
  [89] = {.entry = {.count = 1, .reusable = true}}, SHIFT(58),
  [91] = {.entry = {.count = 1, .reusable = true}}, SHIFT(18),
  [93] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_type_repeat1, 2), SHIFT_REPEAT(33),
  [96] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_type_repeat1, 2),
  [98] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_type, 5),
  [100] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_function, 4, .production_id = 1),
  [102] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_function, 7, .production_id = 6),
  [104] = {.entry = {.count = 1, .reusable = true}}, SHIFT(33),
  [106] = {.entry = {.count = 1, .reusable = true}}, SHIFT(25),
  [108] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_statement, 1),
  [110] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_type, 4),
  [112] = {.entry = {.count = 1, .reusable = true}}, SHIFT(51),
  [114] = {.entry = {.count = 1, .reusable = true}}, SHIFT(60),
  [116] = {.entry = {.count = 1, .reusable = true}}, SHIFT(53),
  [118] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_entity_name_repeat1, 2),
  [120] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_entity_name_repeat1, 2), SHIFT_REPEAT(62),
  [123] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_function, 6, .production_id = 6),
  [125] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_function, 6, .production_id = 4),
  [127] = {.entry = {.count = 1, .reusable = true}}, SHIFT(30),
  [129] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_module, 5, .production_id = 1),
  [131] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_function, 5, .production_id = 1),
  [133] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_entity_name, 2),
  [135] = {.entry = {.count = 1, .reusable = true}}, SHIFT(62),
  [137] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_argument_list_repeat1, 2), SHIFT_REPEAT(51),
  [140] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_argument_list_repeat1, 2),
  [142] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_inline_javascript, 3),
  [144] = {.entry = {.count = 1, .reusable = true}}, SHIFT(11),
  [146] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_function, 6, .production_id = 5),
  [148] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_type_definition, 2),
  [150] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_function, 5, .production_id = 4),
  [152] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_statement, 3, .production_id = 2),
  [154] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_entity_name, 1),
  [156] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_function, 5, .production_id = 5),
  [158] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_argument_list, 4),
  [160] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_argument, 2, .production_id = 3),
  [162] = {.entry = {.count = 1, .reusable = true}}, SHIFT(49),
  [164] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_argument_list, 2),
  [166] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_argument_list, 3),
  [168] = {.entry = {.count = 1, .reusable = true}}, SHIFT(13),
  [170] = {.entry = {.count = 1, .reusable = true}}, SHIFT(56),
  [172] = {.entry = {.count = 1, .reusable = true}}, SHIFT(43),
  [174] = {.entry = {.count = 1, .reusable = true}}, SHIFT(6),
  [176] = {.entry = {.count = 1, .reusable = true}},  ACCEPT_INPUT(),
  [178] = {.entry = {.count = 1, .reusable = true}}, SHIFT(16),
  [180] = {.entry = {.count = 1, .reusable = true}}, SHIFT(63),
  [182] = {.entry = {.count = 1, .reusable = true}}, SHIFT(55),
  [184] = {.entry = {.count = 1, .reusable = true}}, SHIFT(10),
};

#ifdef __cplusplus
extern "C" {
#endif
#ifdef _WIN32
#define extern __declspec(dllexport)
#endif

extern const TSLanguage *tree_sitter_mint(void) {
  static const TSLanguage language = {
    .version = LANGUAGE_VERSION,
    .symbol_count = SYMBOL_COUNT,
    .alias_count = ALIAS_COUNT,
    .token_count = TOKEN_COUNT,
    .external_token_count = EXTERNAL_TOKEN_COUNT,
    .state_count = STATE_COUNT,
    .large_state_count = LARGE_STATE_COUNT,
    .production_id_count = PRODUCTION_ID_COUNT,
    .field_count = FIELD_COUNT,
    .max_alias_sequence_length = MAX_ALIAS_SEQUENCE_LENGTH,
    .parse_table = &ts_parse_table[0][0],
    .small_parse_table = ts_small_parse_table,
    .small_parse_table_map = ts_small_parse_table_map,
    .parse_actions = ts_parse_actions,
    .symbol_names = ts_symbol_names,
    .field_names = ts_field_names,
    .field_map_slices = ts_field_map_slices,
    .field_map_entries = ts_field_map_entries,
    .symbol_metadata = ts_symbol_metadata,
    .public_symbol_map = ts_symbol_map,
    .alias_map = ts_non_terminal_alias_map,
    .alias_sequences = &ts_alias_sequences[0][0],
    .lex_modes = ts_lex_modes,
    .lex_fn = ts_lex,
  };
  return &language;
}
#ifdef __cplusplus
}
#endif
