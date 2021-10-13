module.exports = grammar({
  name: 'mint',
  rules: {
    program: $ => repeat($._top_level),
    _top_level: $ => choice(
      $.comment,
      $.module
    ),
    comment: $ => token(choice(
      seq('//', /.*/),
      seq(
        '/*',
        /[^*]*\*+([^/*][^*]*\*+)*/,
        '/'
      )
    )),
    module: $ => seq(
      'module',
      field('name', $.entity_name),
      '{',
      repeat(choice(
        $.comment,
        $.function
      )),
      '}'
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
    variable: $ => /[a-z][a-zA-Z0-9]*/,
    entity_name: $ => seq(
      $._entity_part,
      optional(repeat(seq('.', $._entity_part)))
    ),
    _entity_part: $ => /[A-Z][a-zA-Z]+/,
    statement: $ => seq(
      optional(seq(
        field('name', $.variable),
        "="
      )),
      choice($.inline_javascript, $.module_access)
    ),
    module_access: $ => seq(
      $.entity_name,
      ".",
      $.variable
    ),
    inline_javascript: $ => seq(
      '`',
      /[^`]*/,
      '`'),
    type_definition: $ => seq(
        ':',
      $.type
    ),
    type: $ => choice(
      $.variable,
      seq(
        $._entity_part,
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
