module Mint
  class Parser
    def type_definition : Ast::TypeDefinition?
      parse do |start_position|
        comment = self.comment
        whitespace

        # TODO: Remove `record` and `enum` in 0.21.0
        next unless keyword!("type") || keyword!("record") || keyword!("enum")
        whitespace

        next error :type_definition_expected_name do
          expected "the name of a type", word
          snippet self
        end unless name = id
        whitespace

        parameters =
          if char! '('
            items = list(separator: ',', terminator: ')') { type_variable }

            whitespace
            next error :type_definition_expected_closing_parenthesis do
              expected "the closing parenthesis of a type definition", word
              snippet self
            end unless char! ')'

            items
          end || [] of Ast::TypeVariable

        whitespace

        fields = begin
          if char! '{'
            variants =
              list(separator: ',', terminator: '}') { type_definition_field }

            items =
              if variants.empty?
                many { type_variant }
              else
                variants
              end

            whitespace
            next error :type_definition_expected_closing_bracket do
              expected "the closing bracket of a type definition", word
              snippet self
            end unless char! '}'

            items
          end || [] of Ast::TypeDefinitionField
        end

        Ast::TypeDefinition.new(
          parameters: parameters,
          from: start_position,
          comment: comment,
          fields: fields,
          to: position,
          name: name,
          file: file)
      end
    end
  end
end
