module Mint
  class Parser
    def return_call : Ast::ReturnCall?
      start do |start_position|
        next unless keyword "return"
        next unless whitespace?
        whitespace

        next error :return_call_expected_expression do
          expected "the expression of a return call", word
          snippet self
        end unless expression = self.expression

        self << Ast::ReturnCall.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
