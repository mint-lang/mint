module Mint
  class Parser
    syntax_error RecordDefinitionFieldExpectedMapping
    syntax_error RecordDefinitionFieldExpectedColon
    syntax_error RecordDefinitionFieldExpectedType

    def record_definition_field : Ast::RecordDefinitionField | Nil
      start do |start_position|
        skip unless key = variable

        whitespace
        char ':', RecordDefinitionFieldExpectedColon
        whitespace

        type = type! RecordDefinitionFieldExpectedType

        mapping =
          start do
            whitespace
            skip unless keyword "from"
            whitespace
            string_literal! RecordDefinitionFieldExpectedMapping
          end

        Ast::RecordDefinitionField.new(
          from: start_position,
          mapping: mapping,
          to: position,
          input: data,
          type: type,
          key: key)
      end
    end
  end
end
