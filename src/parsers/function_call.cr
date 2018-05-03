module Mint
  class Parser
    syntax_error FunctionCallExpectedClosingParentheses

    def function_call : Ast::FunctionCall | Nil
      start do |start_position|
        function = start do
          value = variable
          skip unless char! '('
          value
        end

        skip unless function

        whitespace
        arguments = list(
          terminator: ')',
          separator: ','
        ) { expression.as(Ast::Expression | Nil) }.compact
        whitespace

        char ')', FunctionCallExpectedClosingParentheses

        Ast::FunctionCall.new(
          arguments: arguments,
          from: start_position,
          function: function,
          to: position,
          piped: false,
          input: data)
      end
    end
  end
end
