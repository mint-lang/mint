module Mint
  class Parser
    def encode : Ast::Encode?
      start do |start_position|
        next unless keyword "encode"
        next unless whitespace?
        whitespace

        next error :encode_expected_expression do
          block do
            text "The"
            bold "object to be encoded"
            text "must come from an"
            bold "expression."
          end

          expected "the expression", word
          snippet self
        end unless expression = self.expression

        self << Ast::Encode.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
