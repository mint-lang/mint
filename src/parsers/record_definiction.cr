module Mint
  class Parser
    syntax_error RecordDefinitionExpectedOpeningBracket
    syntax_error RecordDefinitionExpectedClosingBracket
    syntax_error RecordDefinitionExpectedName

    def record_definition : Ast::RecordDefinition | Nil
      start do |start_position|
        comment = self.comment

        skip unless keyword "record"
        whitespace

        name = type_id! RecordDefinitionExpectedName

        fields = block(
          opening_bracket: RecordDefinitionExpectedOpeningBracket,
          closing_bracket: RecordDefinitionExpectedClosingBracket
        ) do
          list(
            terminator: '}',
            separator: ','
          ) { record_definition_field }.compact
        end

        Ast::RecordDefinition.new(
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
