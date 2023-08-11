module Mint
  class Parser
    def record_definition_field : Ast::RecordDefinitionField?
      start do |start_position|
        comment = self.comment

        next unless key = variable
        whitespace

        next error :record_definition_field_expected_colon do
          expected "the colon separating a record field from the type", word
          snippet self
        end unless char! ':'
        whitespace

        next error :record_definition_field_expected_type do
          expected "the type of a record field", word
          snippet self
        end unless type = self.type

        mapping =
          start do
            whitespace
            next unless keyword "using"
            whitespace

            next error :record_definition_field_expected_mapping do
              expected "the mapping of a record field", word
              snippet self
            end unless item = string_literal with_interpolation: false

            item
          end

        self << Ast::RecordDefinitionField.new(
          from: start_position,
          comment: comment,
          mapping: mapping,
          to: position,
          input: data,
          type: type,
          key: key)
      end
    end
  end
end
