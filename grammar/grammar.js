module.exports = grammar({
  name: 'mint',
  conflicts: $ => [
    [$.entity_name],
    [$.statement, $.call],
    [$.case_branch, $.call],
    [$._basic_expression, $.tuple_destructuring],
    [$.array, $.call],
    [$.statement, $.record_field],
    [$.call, $.negation],
    [$.member, $.negation],
    [$.operation, $.negation],
    [$.tuple, $.block],
    [$.tuple, $.statement],
    [$.access, $.statement],
    [$.access, $.array],
    [$.access, $.negation],
    [$.access, $.case_branch]
  ],
  externals: $ => [
    $.string_chars,
    $.javascript_chars
  ],
  rules: {
    program: $ => repeat($._top_level),

    variable: $ => /[a-z][a-zA-Z0-9]*/,
    constant: $ => /[A-Z][A-Z0-9_]*/,

    _top_level: $ => choice(
      $.record_definition,
      $.enum_definition,
      $.component,
      $.comment,
      $.module,
    ),

    comment: $ => token(choice(
      seq('//', /.*/),
      seq(
        '/*',
        /[^*]*\*+([^/*][^*]*\*+)*/,
        '/'
      )
    )),

    property: $ => seq(
      'property',
      $.variable,
      optional($.type_definition),
      "=",
      $._expression
    ),

    record_definition_field: $ => seq(
      $.variable,
      $.type_definition
    ),

    record_definition: $ => seq(
      'record',
      field('name', $.entity_name),
      '{',
      commaSep1($.record_definition_field),
      '}'
    ),

    record_update: $ => seq(
      '{',
      $.variable,
      '|',
      commaSep($.record_field),
      '}'
    ),

    enum_definition: $ => seq(
      'enum',
      field('name', $.entity_name),
      optional(seq('(',commaSep($.variable),')')),
      '{',
      repeat(choice(
        $.comment,
        $.type)),
      '}'
    ),

    component: $ => seq(
      'component',
      $.entity_name,
      '{',
      repeat(choice(
        $.property,
        $.function,
        $.comment,
        $.const,
      )),
      '}'
    ),

    module: $ => seq(
      'module',
      field('name', $.entity_name),
      '{',
      repeat(choice(
        $.comment,
        $.function,
        $.const
      )),
      '}'
    ),

    const: $ => seq(
      'const',
      $.constant,
      '=',
      $._expression
    ),

    function: $ => seq(
      'fun',
      field('name', $.variable),
      field('arguments', optional($.argument_list)),
      field('type', optional($.type_definition)),
      '{',
      repeat($.statement),
      '}'
    ),

    argument_list: $ => seq(
      '(',
      commaSep($.argument),
      ')'
    ),

    argument: $ => seq(
      field('name', $.variable),
      field('type', optional($.type_definition))
    ),

    entity_name: $ => seq(
      $._entity_part,
      optional(repeat(seq('.', $._entity_part)))
    ),

    _entity_part: $ => /[A-Z][a-zA-Z]+/,

    statement: $ => seq(
      optional(seq(
        field('name', choice($.variable, $.tuple_destructuring)),
        "="
      )),
      $._expression
    ),

    array: $ => seq(
      '[',
      repeat($._expression),
      ']'
    ),

    tuple: $ => seq(
      '{',
      commaSep($._expression),
      '}'
    ),

    inline_function: $ => seq(
      $.argument_list,
      optional($.type_definition),
      $.block
    ),

    number: $ => {
      const decimal_digits = /\d(_?\d)*/

      const decimal_integer_literal = choice(
        '0',
        seq(optional('0'), /[1-9]/, optional(seq(optional('_'), decimal_digits)))
      )

      return token(choice(
        seq(decimal_integer_literal, '.', optional(decimal_digits)),
        seq(decimal_integer_literal),
        seq(decimal_digits),
      ))
    },

    _basic_expression: $ => choice(
      $.string,
      $.bool,
      $.variable,
      $.entity_name,
      $.record,
      $.record_update,
      $.inline_javascript,
      $.inline_function,
      $.enum,
      $.tuple,
      $.number,
      $.case,
      $.constant,
      $.negation,
      $.operation,
      $.array,
      $.if,
      $.block,
    ),

    bool: $ => choice('true', 'false'),

    enum: $ => seq(
      $.entity_name,
      '::',
      $.entity_name,
    ),

    record_field: $ => seq(
      $.variable,
      '=',
      $._expression,
    ),

    record: $ => seq(
      '{',
      commaSep1($.record_field),
      '}'
    ),

    case_branch: $ => seq(
      optional($._expression),
      '=>',
      $._expression
    ),

    case: $ => seq(
      'case',
      '(',
      $._expression,
      ')',
      '{',
      repeat($.case_branch),
      '}'
    ),

    if: $ => seq(
      'if',
      '(',
      $._expression,
      ')',
      '{',
      $._expression,
      '}',
      optional($.else)
    ),

    else: $ => seq(
      'else',
      '{',
      $._expression,
      '}'
    ),

    arguments: $ => seq(
      '(',
      commaSep(optional($._expression)),
      ')'
    ),

    _expression: $ => choice(
      $.call,
      $.member,
      $.access,
      $._basic_expression,
    ),

    tuple_destructuring: $ => seq(
      '{', commaSep($.variable), '}'
    ),

    block: $ => seq(
      '{',
      repeat($.statement),
      '}'
    ),

    parenthesized_expression: $ => seq(
      '(',
      $._expression,
      ')'
    ),

    negation: $ => seq(
      '!',
      $._expression,
    ),

    operation: $ => choice(
      ...[
        ["|>", 0],
        ["or", 0],
        ["!=", 10],
        ["==", 10],
        ["<=", 11],
        ["<", 11],
        [">=", 11],
        [">", 11],
        ["-", 13],
        ["+", 13],
        ["*", 14],
        ["/", 14],
        ["%", 14],
        ["**", 15],
        ["&&", 6],
        ["||", 5],
      ].map(([operator, precedence]) =>
        prec.left(precedence, seq(
          field('left', $._expression),
          field('operator', operator),
          field('right', $._expression)
        ))
      )
    ),

    member: $ => seq(
      field('entity', $._expression),
      ".",
      field('variable', $.variable)
    ),

    access: $ => seq(
      field('entity', $._expression),
      "[",
      field('variable', $._expression),
      "]"
    ),

    call: $ => seq(
      field('epxression', $._expression),
      field('arguments', $.arguments)
    ),

    interpolation: $ => seq(
      "#{",
      $._expression,
      "}"
    ),

    inline_javascript: $ => seq(
      '`',
      repeat(choice($.javascript_chars, $.interpolation)),
      '`'
    ),

    type_definition: $ => seq(
      ':',
      $.type
    ),

    string: $ => seq(
      '"',
      repeat(choice($.string_chars, $.interpolation)),
      '"',
      optional(seq("\\", $.string))
    ),

    type: $ => choice(
      $.variable,
      seq(
        $.entity_name,
        optional(seq(
          "(",
          commaSep($.type),
          ")"))
      ))
  }
});

function commaSep1(rule) {
  return seq(rule, repeat(seq(',', rule)));
}

function commaSep(rule) {
  return optional(commaSep1(rule));
}
