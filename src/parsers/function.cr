class Parser
  syntax_error FunctionExpectedClosingParentheses
  syntax_error FunctionExpectedOpeningBracket
  syntax_error FunctionExpectedClosingBracket
  syntax_error FunctionExpectedTypeOrVariable
  syntax_error FunctionExpectedExpression
  syntax_error FunctionExpectedColon
  syntax_error FunctionExpectedName

  def function : Ast::Function | Nil
    start do |start_position|
      skip unless keyword "fun"

      whitespace
      name = variable! FunctionExpectedName
      whitespace

      arguments = [] of Ast::Argument

      if char! '('
        whitespace

        arguments.concat list(
          terminator: ')',
          separator: ','
        ) { argument }.compact

        whitespace
        char ')', FunctionExpectedClosingParentheses
      end

      whitespace
      char ':', FunctionExpectedColon
      whitespace

      type = type_or_type_variable! FunctionExpectedTypeOrVariable

      body = block(
        opening_bracket: FunctionExpectedOpeningBracket,
        closing_bracket: FunctionExpectedClosingBracket
      ) do
        expression! FunctionExpectedExpression
      end

      whitespace

      Ast::Function.new(
        arguments: arguments,
        from: start_position,
        wheres: where,
        to: position,
        input: data,
        name: name,
        type: type,
        body: body)
    end
  end
end
