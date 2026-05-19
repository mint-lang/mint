/**
 * @file Mint grammar for tree-sitter
 * @license MIT
 *
 * Mirrors the recursive-descent parser in `src/parsers/` of the Mint compiler.
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

// Operator precedences, matching `src/parsers/operator.cr`.
const OPERATORS = [
  ['||', 5],
  ['&&', 6],
  ['==', 10],
  ['!=', 10],
  ['<=', 11],
  ['>=', 11],
  ['<', 11],
  ['>', 11],
  ['+', 13],
  ['-', 13],
  ['*', 14],
  ['/', 14],
  ['%', 14],
  ['**', 15],
];

// Precedences for resolving ambiguities. Higher binds tighter.
const PREC = {
  comment: 20,
  html: 18, // prefer an HTML element over the `<` operator
  chain: 19, // access / call / bracket access
  unary: 17,
  pipe: 1,
  or_operation: 1,
  block: 2, // prefer block over record/tuple/map when ambiguous
  record_update: 4,
  record: 3,
  tuple: 3,
  map: 3,
};

module.exports = grammar({
  name: 'mint',

  // The order of these must match the `TokenType` enum in `src/scanner.c`.
  externals: $ => [
    $.string_content,
    $.js_content,
    $.css_value_content,
    // The SCREAMING_CASE terminator of a here document. The scanner stores
    // it so the matching closing token can be found exactly.
    $.here_document_token,
    $.here_document_content,
    $.here_document_end,
    // The `<` that opens an HTML element/component/fragment. Emitted by the
    // scanner only when `<` is immediately followed by a tag character, so
    // it never collides with the `<` comparison operator.
    $._html_open,
    // The text of a CSS selector. The scanner emits it only when a `{`
    // appears before any `;`/`}`, so it never swallows a `css_definition`
    // (which is `property : value ;`).
    $.css_selector_name,
  ],

  extras: $ => [
    /\s/,
    $.comment,
  ],

  word: $ => $.variable,

  conflicts: $ => [
    [$.record_destructuring, $.tuple_destructuring],
    [$.type],
    [$.parenthesized_expression, $.case],
    [$.parenthesized_expression, $.css_case],
  ],

  rules: {
    program: $ => repeat($._top_level),

    _top_level: $ => choice(
      $.module_definition,
      $.type_definition,
      $.component,
      $.provider,
      $.store,
      $.suite,
      $.routes,
      $.locale,
    ),

    // ---------------------------------------------------------------------
    // Comments
    // ---------------------------------------------------------------------

    comment: $ => token(choice(
      seq('//', /[^\n]*/),
      seq('/*', /[^*]*\*+([^/*][^*]*\*+)*/, '/'),
    )),

    // ---------------------------------------------------------------------
    // Identifiers
    // ---------------------------------------------------------------------

    // The single identifier token (`value` in the compiler): any case, may
    // contain underscores, never dotted. It is the `word` token, so keyword
    // extraction applies to it. It is the sole identifier lexeme — a
    // variable, a constant name and a type variable are all `variable`
    // nodes, distinguished by their position in the tree (which is enough
    // for highlighting). Dotted type names are built as `id`.
    variable: _ => /[a-zA-Z][a-zA-Z0-9_]*/,

    // A possibly-dotted type identifier (`identifier_type`): `Foo`,
    // `Html.Event`. A single token. Used only in type positions and as an
    // HTML component name, where access chains are never built — so its
    // greediness over `.` is harmless here.
    id: _ => token(prec(1, /[A-Z][a-zA-Z0-9]*(\.[A-Z][a-zA-Z0-9]*)*/)),

    discard: _ => '_',

    // ---------------------------------------------------------------------
    // Type definitions
    // ---------------------------------------------------------------------

    type_definition: $ => seq(
      'type',
      field('name', $.id),
      optional($.type_parameters),
      optional(seq(
        '{',
        choice(
          commaSep($.type_definition_field),
          repeat($.type_variant),
        ),
        '}',
      )),
      optional(seq('context', $._expression)),
    ),

    type_parameters: $ => seq(
      '(',
      commaSep($.variable),
      ')',
    ),

    type_definition_field: $ => seq(
      field('key', $.variable),
      ':',
      field('type', choice($.type, $.variable)),
      optional(seq('using', $.string)),
    ),

    type_variant: $ => seq(
      field('name', $.id),
      optional(seq(
        '(',
        commaSep(choice(
          $.type_definition_field,
          $.variable,
          $.type,
        )),
        ')',
      )),
    ),

    type: $ => prec(1, seq(
      field('name', $.id),
      optional(seq(
        '(',
        commaSep(choice($.type, $.variable)),
        ')',
      )),
    )),

    type_annotation: $ => seq(':', choice($.type, $.variable)),

    // ---------------------------------------------------------------------
    // Modules, components, stores, providers, suites
    // ---------------------------------------------------------------------

    module_definition: $ => seq(
      'module',
      field('name', $.id),
      '{',
      repeat(choice($.function, $.constant)),
      '}',
    ),

    component: $ => seq(
      optional('global'),
      optional('async'),
      'component',
      field('name', $.id),
      '{',
      repeat(choice(
        $.property,
        $.constant,
        $.function,
        $.context,
        $.provide,
        $.connect,
        $.style,
        $.state,
        $.use,
        $.get,
      )),
      '}',
    ),

    store: $ => seq(
      'store',
      field('name', $.id),
      '{',
      repeat(choice(
        $.signal,
        $.state,
        $.function,
        $.get,
        $.constant,
      )),
      '}',
    ),

    provider: $ => seq(
      'provider',
      field('name', $.id),
      ':',
      field('subscription', $.id),
      '{',
      repeat(choice(
        $.signal,
        $.function,
        $.state,
        $.get,
        $.constant,
      )),
      '}',
    ),

    suite: $ => seq(
      'suite',
      field('name', $.string),
      '{',
      repeat(choice($.function, $.constant, $.test)),
      '}',
    ),

    routes: $ => seq(
      'routes',
      '{',
      repeat($.route),
      '}',
    ),

    locale: $ => seq(
      'locale',
      field('language', $.variable),
      '{',
      commaSep($.record_field),
      '}',
    ),

    // ---------------------------------------------------------------------
    // Component / store / provider members
    // ---------------------------------------------------------------------

    function: $ => seq(
      'fun',
      field('name', $.variable),
      optional($.argument_list),
      optional($.type_annotation),
      field('body', $.block),
    ),

    constant: $ => seq(
      'const',
      field('name', $.variable),
      '=',
      field('value', $._expression),
    ),

    property: $ => seq(
      'property',
      field('name', $.variable),
      optional($.type_annotation),
      optional(seq('=', field('default', $._expression))),
    ),

    state: $ => seq(
      'state',
      field('name', $.variable),
      optional($.type_annotation),
      '=',
      field('default', $._expression),
    ),

    get: $ => seq(
      'get',
      field('name', $.variable),
      optional($.type_annotation),
      field('body', $.block),
    ),

    context: $ => seq(
      'context',
      field('name', $.variable),
      ':',
      field('type', $.type),
    ),

    signal: $ => seq(
      'signal',
      field('name', $.variable),
      ':',
      field('type', $.type),
      field('body', $.block),
    ),

    use: $ => seq(
      'use',
      field('provider', $.id),
      field('data', $.record),
      optional(seq('when', $.block)),
    ),

    provide: $ => seq(
      'provide',
      field('name', $.id),
      field('expression', $._expression),
    ),

    connect: $ => seq(
      'connect',
      field('store', $.id),
      'exposing',
      '{',
      commaSep($.connect_variable),
      '}',
    ),

    connect_variable: $ => seq(
      field('name', $.variable),
      optional(seq('as', field('target', $.variable))),
    ),

    style: $ => seq(
      'style',
      field('name', alias($._style_name, $.variable)),
      optional($.argument_list),
      '{',
      repeat($._css_node),
      '}',
    ),

    _style_name: _ => /[a-z][a-zA-Z0-9-]*/,

    test: $ => seq(
      'test',
      field('name', $.string),
      field('body', $.block),
    ),

    route: $ => seq(
      field('url', choice('*', $._route_url)),
      optional($.argument_list),
      optional('await'),
      field('body', $.block),
    ),

    _route_url: _ => token(prec(-1, /\/[^\s{(]*/)),

    // ---------------------------------------------------------------------
    // Arguments
    // ---------------------------------------------------------------------

    argument_list: $ => seq(
      '(',
      commaSep($.argument),
      ')',
    ),

    argument: $ => seq(
      field('name', $.variable),
      ':',
      field('type', choice($.type, $.variable)),
      optional(seq('=', field('default', $._expression))),
    ),

    // ---------------------------------------------------------------------
    // Blocks and statements
    // ---------------------------------------------------------------------

    block: $ => prec.right(PREC.block, seq(
      '{',
      repeat1($.statement),
      '}',
      optional($.block_fallback),
    )),

    block_fallback: $ => seq(
      'or',
      choice('return', $._expression),
    ),

    statement: $ => prec.right(seq(
      optional(seq('let', field('target', $._destructuring), '=')),
      field('expression', $._expression),
      optional(seq('or', 'return', $._expression)),
    )),

    // ---------------------------------------------------------------------
    // Expressions
    // ---------------------------------------------------------------------

    _expression: $ => choice(
      $.operation,
      $.pipe,
      $._base_expression,
    ),

    _base_expression: $ => choice(
      $.access,
      $.call,
      $.bracket_access,
      $._primary_expression,
    ),

    _primary_expression: $ => choice(
      $.parenthesized_expression,
      $.inline_function,
      $.number_literal,
      $.unary_minus,
      $.negated_expression,
      $.string,
      $.regexp_literal,
      $.tuple,
      $.field_access,
      $.array_literal,
      $.locale_key,
      $.js,
      $.env,
      $.directive,
      $.builtin,
      $.html_element,
      $.html_component,
      $.html_fragment,
      $.here_document,
      $.record_update,
      $.record,
      $.map,
      $.block,
      $.bool_literal,
      $.case,
      $.for,
      $.if,
      $.next_call,
      $.decode,
      $.encode,
      $.await,
      $.defer,
      $.emit,
      $.dbg,
      $.variable,
    ),

    parenthesized_expression: $ => seq('(', $._expression, ')'),

    bool_literal: _ => choice('true', 'false'),

    number_literal: _ => token(seq(
      /\d+/,
      optional(seq('.', /\d+/)),
    )),

    unary_minus: $ => prec(PREC.unary, seq('-', $._expression)),

    negation: _ => token(/!+/),
    negated_expression: $ => prec(PREC.unary, seq(
      $.negation,
      $._expression,
    )),

    // ---------------------------------------------------------------------
    // Operations and pipes
    // ---------------------------------------------------------------------

    operation: $ => choice(
      ...OPERATORS.map(([operator, precedence]) =>
        prec.left(precedence, seq(
          field('left', $._expression),
          field('operator', operator),
          field('right', $._expression),
        )),
      ),
      // `or` operator (used outside `or return`).
      prec.left(PREC.or_operation, seq(
        field('left', $._expression),
        field('operator', 'or'),
        field('right', $._expression),
      )),
    ),

    pipe: $ => prec.left(PREC.pipe, seq(
      field('argument', $._expression),
      '|>',
      field('expression', $._expression),
    )),

    // ---------------------------------------------------------------------
    // Chained access / calls
    // ---------------------------------------------------------------------

    access: $ => prec(PREC.chain, seq(
      field('expression', $._base_expression),
      '.',
      field('field', $.variable),
    )),

    bracket_access: $ => prec(PREC.chain, seq(
      field('expression', $._base_expression),
      '[',
      field('index', $._expression),
      ']',
    )),

    call: $ => prec(PREC.chain, seq(
      field('expression', $._base_expression),
      $.arguments,
    )),

    arguments: $ => seq(
      '(',
      commaSep($._call_argument),
      ')',
    ),

    _call_argument: $ => choice(
      $.discard,
      $.record_field,
      $._expression,
    ),

    // ---------------------------------------------------------------------
    // Records, maps, tuples, arrays
    // ---------------------------------------------------------------------

    record: $ => prec(PREC.record, seq(
      '{',
      commaSep1($.record_field),
      '}',
    )),

    record_update: $ => prec(PREC.record_update, seq(
      '{',
      field('subject', $._expression),
      '|',
      commaSep1($.record_field),
      '}',
    )),

    record_field: $ => seq(
      field('key', $.variable),
      ':',
      field('value', choice($._expression, $.discard)),
    ),

    map: $ => prec(PREC.map, seq(
      '{',
      commaSep($.map_field),
      '}',
      optional(seq(
        'of',
        choice($.type, $.variable),
        '=>',
        choice($.type, $.variable),
      )),
    )),

    map_field: $ => seq(
      field('key', $._expression),
      '=>',
      field('value', $._expression),
    ),

    tuple: $ => prec(PREC.tuple, seq(
      '{',
      $._expression,
      ',',
      commaSep1($._expression),
      '}',
    )),

    array_literal: $ => seq(
      '[',
      commaSep($._expression),
      ']',
      optional(seq('of', choice($.type, $.variable))),
    ),

    // ---------------------------------------------------------------------
    // Inline functions
    // ---------------------------------------------------------------------

    inline_function: $ => seq(
      $.argument_list,
      optional($.type_annotation),
      field('body', $.block),
    ),

    // ---------------------------------------------------------------------
    // Control flow
    // ---------------------------------------------------------------------

    if: $ => prec.right(seq(
      'if',
      field('condition', choice($.statement, $._expression)),
      field('truthy', $.block),
      optional(seq('else', field('falsy', choice($.block, $.if)))),
    )),

    case: $ => seq(
      'case',
      choice(
        seq('(', field('condition', $._expression), ')'),
        field('condition', $._expression),
      ),
      '{',
      repeat($.case_branch),
      '}',
    ),

    case_branch: $ => seq(
      optional(field('patterns', sep1('|', $._destructuring))),
      '=>',
      field('body', $._expression),
    ),

    for: $ => prec.right(seq(
      'for',
      choice(
        seq('(', commaSep1($._destructuring), ')'),
        commaSep1($._destructuring),
      ),
      'of',
      field('subject', $._expression),
      field('body', $.block),
      optional(seq('when', $.block)),
    )),

    // ---------------------------------------------------------------------
    // Keyword expressions
    // ---------------------------------------------------------------------

    next_call: $ => seq('next', $.record),

    decode: $ => seq(
      'decode',
      optional($._expression),
      'as',
      $.type,
    ),

    encode: $ => seq('encode', $._expression),
    await: $ => prec.right(seq('await', $._base_expression)),
    defer: $ => prec.right(seq('defer', $._expression)),
    emit: $ => prec.right(seq('emit', $._expression)),
    dbg: $ => prec.right(seq('dbg', optional('!'), optional($._expression))),

    // ---------------------------------------------------------------------
    // Destructuring (patterns)
    // ---------------------------------------------------------------------

    _destructuring: $ => choice(
      $.array_destructuring,
      $.record_destructuring,
      $.tuple_destructuring,
      $.type_destructuring,
      $.string,
      $.number_literal,
      $.bool_literal,
      $.variable,
      $.discard,
    ),

    array_destructuring: $ => seq(
      '[',
      commaSep(choice($.spread, $._destructuring)),
      ']',
    ),

    record_destructuring: $ => seq(
      '{',
      commaSep($.record_destructuring_field),
      '}',
    ),

    record_destructuring_field: $ => seq(
      field('key', $.variable),
      ':',
      field('value', $._destructuring),
    ),

    tuple_destructuring: $ => seq(
      '{',
      commaSep($._destructuring),
      '}',
    ),

    type_destructuring: $ => prec(1, seq(
      field('name', $.id),
      optional(seq(
        '(',
        commaSep($._destructuring),
        ')',
      )),
    )),

    spread: $ => seq('...', choice($.variable, $.discard)),

    // ---------------------------------------------------------------------
    // Field access
    // ---------------------------------------------------------------------

    field_access: $ => seq(
      '.',
      field('name', $.variable),
      '(',
      field('type', $.type),
      ')',
    ),

    // ---------------------------------------------------------------------
    // Strings, JS, regexps, here documents
    // ---------------------------------------------------------------------

    string: $ => seq(
      '"',
      repeat(choice($.string_content, $.interpolation, $.escape_sequence)),
      '"',
      // Broken strings can be continued with a backslash.
      optional(seq('\\', $.string)),
    ),

    escape_sequence: _ => token.immediate(/\\(.|\n)/),

    js: $ => prec.right(seq(
      '`',
      repeat(choice($.js_content, $.interpolation)),
      '`',
      optional(seq('as', choice($.type, $.variable))),
    )),

    interpolation: $ => seq(
      '#{',
      $._expression,
      '}',
    ),

    regexp_literal: $ => token(seq(
      '/',
      /[^/*\n][^/\n]*/,
      '/',
      /[igmsuy]*/,
    )),

    here_document: $ => seq(
      '<<',
      choice('~', '#', '-'),
      field('token', $.here_document_token),
      optional(seq('(', optional('highlight'), ')')),
      repeat(choice($.here_document_content, $.interpolation)),
      field('end', $.here_document_end),
    ),

    // ---------------------------------------------------------------------
    // Misc literals
    // ---------------------------------------------------------------------

    locale_key: _ => token(seq(':', /[a-z][a-zA-Z0-9.]*/)),

    env: $ => seq('@', $.variable),

    builtin: $ => seq('%', $.variable, '%'),

    // ---------------------------------------------------------------------
    // Directives
    // ---------------------------------------------------------------------

    directive: $ => choice(
      $.path_directive,
      $.size_directive,
      $.block_directive,
    ),

    // `@asset(path)`, `@inline(path)`, `@svg(path)`, `@highlight-file(path)`.
    path_directive: $ => seq(
      field('name', choice('@asset', '@inline', '@svg', '@highlight-file')),
      '(',
      field('path', alias($._directive_path, $.path)),
      ')',
    ),

    _directive_path: _ => token(prec(-1, /[^)]+/)),

    // `@size(ref)`.
    size_directive: $ => seq(
      '@size',
      '(',
      field('ref', $.variable),
      ')',
    ),

    // `@format { ... }`, `@highlight { ... }`.
    block_directive: $ => seq(
      field('name', choice('@format', '@highlight')),
      field('body', $.block),
    ),

    // ---------------------------------------------------------------------
    // HTML
    // ---------------------------------------------------------------------

    html_element: $ => prec(PREC.html, seq(
      alias($._html_open, $.html_punctuation),
      field('tag', alias(token.immediate(/[a-z][a-zA-Z0-9-]*/), $.html_tag)),
      repeat($.html_style),
      optional(seq('as', field('ref', $.variable))),
      repeat($.html_attribute),
      choice(
        alias('/>', $.html_punctuation),
        seq(
          alias('>', $.html_punctuation),
          repeat($._expression),
          field('closing_tag', $.html_closing_tag),
        ),
      ),
    )),

    // The `</tag>` that closes an HTML element. The tag name is a visible
    // `html_tag` node so it highlights like the opening tag. The angle
    // brackets are `html_punctuation` so they can be left uncoloured,
    // distinct from the `<`/`>` comparison operators.
    html_closing_tag: $ => seq(
      alias('</', $.html_punctuation),
      alias(token.immediate(/[a-z][a-zA-Z0-9-]*/), $.html_tag),
      alias(token.immediate('>'), $.html_punctuation),
    ),

    html_component: $ => prec(PREC.html, seq(
      alias($._html_open, $.html_punctuation),
      field('component', alias(token.immediate(/[A-Z][a-zA-Z0-9]*(\.[A-Z][a-zA-Z0-9]*)*/), $.id)),
      optional(seq('as', field('ref', $.variable))),
      repeat($.html_attribute),
      choice(
        alias('/>', $.html_punctuation),
        seq(
          alias('>', $.html_punctuation),
          repeat($._expression),
          field('closing_tag', $.html_component_closing_tag),
        ),
      ),
    )),

    // The `</Component>` that closes an HTML component.
    html_component_closing_tag: $ => seq(
      alias('</', $.html_punctuation),
      alias(token.immediate(/[A-Z][a-zA-Z0-9]*(\.[A-Z][a-zA-Z0-9]*)*/), $.id),
      alias(token.immediate('>'), $.html_punctuation),
    ),

    html_fragment: $ => prec(PREC.html, seq(
      alias($._html_open, $.html_punctuation),
      alias(token.immediate('>'), $.html_punctuation),
      repeat($._expression),
      alias('</>', $.html_punctuation),
    )),

    html_attribute: $ => seq(
      field('name', alias($._html_attribute_name, $.html_attribute_name)),
      '=',
      field('value', choice(
        $.html_fragment,
        $.string,
        $.array_literal,
        $.block,
      )),
    ),

    _html_attribute_name: _ => /[a-z][a-zA-Z0-9:-]*/,

    html_style: $ => seq(
      '::',
      field('name', alias($._style_name, $.variable)),
      optional($.arguments),
    ),

    // ---------------------------------------------------------------------
    // CSS
    // ---------------------------------------------------------------------

    _css_node: $ => choice(
      $.css_definition,
      $.css_selector,
      $.css_nested_at,
      $.css_keyframes,
      $.css_font_face,
      $.css_case,
      $.css_if,
    ),

    css_definition: $ => seq(
      field('name', alias($._css_property_name, $.css_property)),
      ':',
      field('value', repeat1(choice(
        $.string,
        $.interpolation,
        $.css_value_content,
      ))),
      ';',
    ),

    // A CSS-context `if`: branches hold CSS definitions instead of
    // statements (`if_expression(for_css: true)` in the compiler).
    css_if: $ => prec.right(seq(
      'if',
      field('condition', choice($.statement, $._expression)),
      field('truthy', $.css_block),
      optional(seq('else', field('falsy', choice($.css_block, $.css_if)))),
    )),

    css_block: $ => seq(
      '{',
      repeat($.css_definition),
      '}',
    ),

    // A CSS-context `case`: each branch holds CSS definitions
    // (`case_expression(for_css: true)` in the compiler).
    css_case: $ => seq(
      'case',
      choice(
        seq('(', field('condition', $._expression), ')'),
        field('condition', $._expression),
      ),
      '{',
      repeat($.css_case_branch),
      '}',
    ),

    css_case_branch: $ => seq(
      optional(field('patterns', sep1('|', $._destructuring))),
      '=>',
      field('body', choice(
        $.css_block,
        repeat1($.css_definition),
      )),
    ),

    _css_property_name: _ => /[a-z-][a-zA-Z0-9-]*/,

    css_selector: $ => seq(
      field('selectors', sep1(',', $.css_selector_name)),
      '{',
      repeat($._css_node),
      '}',
    ),

    css_nested_at: $ => seq(
      token(seq('@', choice('media', 'supports'))),
      alias($._css_at_condition, $.css_condition),
      '{',
      repeat($._css_node),
      '}',
    ),

    _css_at_condition: _ => token(prec(-1, /[^{]+/)),

    css_keyframes: $ => seq(
      '@keyframes',
      field('name', alias($._css_at_condition, $.css_keyframes_name)),
      '{',
      repeat($.css_selector),
      '}',
    ),

    css_font_face: $ => seq(
      '@font-face',
      '{',
      repeat($.css_definition),
      '}',
    ),
  },
});

/**
 * Comma-separated list of one or more `rule`s, allowing a trailing comma.
 * @param {RuleOrLiteral} rule
 */
function commaSep1(rule) {
  return seq(rule, repeat(seq(',', rule)), optional(','));
}

/**
 * Comma-separated list of zero or more `rule`s.
 * @param {RuleOrLiteral} rule
 */
function commaSep(rule) {
  return optional(commaSep1(rule));
}

/**
 * `separator`-separated list of one or more `rule`s.
 * @param {RuleOrLiteral} separator
 * @param {RuleOrLiteral} rule
 */
function sep1(separator, rule) {
  return seq(rule, repeat(seq(separator, rule)));
}
