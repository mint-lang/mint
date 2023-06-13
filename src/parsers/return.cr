module Mint
  class Parser
    syntax_error ReturnCallExpectedExpression

    def return_call : Ast::ReturnCall?
      start do |start_position|
        next unless keyword "return"
        next unless whitespace?
        whitespace

        raise ReturnCallExpectedExpression unless expression = self.expression

        self << Ast::ReturnCall.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
