class Parser
  syntax_error RecordDefinitionFieldExpectedColon
  syntax_error RecordDefinitionFieldExpectedType

  def record_definition_field : Ast::RecordDefinitionField | Nil
    start do |start_position|
      skip unless key = variable

      whitespace
      char ':', RecordDefinitionFieldExpectedColon
      whitespace

      type = type! RecordDefinitionFieldExpectedType

      Ast::RecordDefinitionField.new(
        from: start_position,
        to: position,
        input: data,
        type: type,
        key: key)
    end
  end
end
