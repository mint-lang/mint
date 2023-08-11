module Mint
  class Parser
    def record_definition : Ast::RecordDefinition?
      start do |start_position|
        comment = self.comment

        next unless keyword "record"
        whitespace

        next error :record_definition_expected_name do
          expected "the name of a record definition", word
          snippet self
        end unless name = type_id

        fields, block_comment = block2(
          ->{ error :record_definition_expected_opening_bracket do
            expected "the opening bracket of a record definition", word
            snippet self
          end },
          ->{ error :record_definition_expected_closing_bracket do
            expected "the closing bracket of a record definition", word
            snippet self
          end }
        ) do
          {
            list(
              terminator: '}',
              separator: ','
            ) { record_definition_field },
            self.comment,
          }
        end

        self << Ast::RecordDefinition.new(
          block_comment: block_comment,
          from: start_position,
          comment: comment,
          fields: fields,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
