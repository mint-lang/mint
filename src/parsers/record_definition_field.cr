module Mint
  class Parser
    syntax_error RecordDefinitionFieldExpectedMapping
    syntax_error RecordDefinitionFieldExpectedColon
    syntax_error RecordDefinitionFieldExpectedType

    def record_definition_field : Ast::RecordDefinitionField?
      start do |start_position|
        comment = self.comment

        skip unless key = variable
        whitespace

        char ':', RecordDefinitionFieldExpectedColon
        whitespace

        type = type! RecordDefinitionFieldExpectedType

        mapping =
          start do
            whitespace
            skip unless keyword "using"
            whitespace
            string_literal! RecordDefinitionFieldExpectedMapping,
              with_interpolation: false
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
