module Mint
  class Parser
    def encode : Ast::Encode?
      parse do |start_position|
        next unless keyword! "encode"
        whitespace

        next error :encode_expected_expression do
          block do
            text "The"
            bold "object to be encoded"
            text "must come from an"
            bold "expression,"
            text "here is an example:"
          end

          snippet %(encode "A string for example!")
          expected "the expression", word
          snippet self
        end unless expression = self.expression

        Ast::Encode.new(
          expression: expression,
          from: start_position,
          to: position,
          file: file)
      end
    end
  end
end
