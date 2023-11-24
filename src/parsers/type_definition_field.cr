module Mint
  class Parser
    def type_definition_field(*, raise_on_colon : Bool = true) : Ast::TypeDefinitionField?
      parse do |start_position|
        comment = self.comment
        whitespace

        next unless key = variable
        whitespace

        if raise_on_colon
          next error :type_definition_field_expected_colon do
            expected "the colon separating a type field from the type", word
            snippet self
          end unless char! ':'
        else
          next unless char! ':'
        end

        whitespace
        next error :type_definition_field_expected_type do
          expected "the type of a type field", word
          snippet self
        end unless type = self.type || type_variable

        mapping =
          parse(track: false) do
            whitespace
            next unless keyword! "using"
            whitespace

            next error :type_definition_field_expected_mapping do
              expected "the mapping of a record field", word
              snippet self
            end unless item = string_literal with_interpolation: false

            item
          end

        Ast::TypeDefinitionField.new(
          from: start_position,
          comment: comment,
          mapping: mapping,
          to: position,
          type: type,
          file: file,
          key: key)
      end
    end
  end
end
