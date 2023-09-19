module Mint
  class Parser
    def return_call : Ast::ReturnCall?
      parse do |start_position|
        next unless word! "return"
        whitespace

        next error :return_call_expected_expression do
          expected "the expression of a return call", word
          snippet self
        end unless expression = self.expression

        Ast::ReturnCall.new(
          expression: expression,
          from: start_position,
          to: position,
          file: file)
      end
    end
  end
end
