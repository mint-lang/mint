module Mint
  class Parser
    def map_field : Ast::MapField?
      parse do |start_position|
        comment = self.comment

        whitespace
        next unless key = expression

        whitespace
        next unless word! "=>"

        whitespace
        next error :map_field_expected_expression do
          expected "the value of a map field", word
          snippet self
        end unless value = expression

        Ast::MapField.new(
          from: start_position,
          comment: comment,
          value: value,
          to: position,
          file: file,
          key: key)
      end
    end
  end
end
