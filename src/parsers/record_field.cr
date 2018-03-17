class Parser
  syntax_error RecordFieldExpectedExpression
  syntax_error RecordFieldExpectedEqualSign

  def record_field : Ast::RecordField | Nil
    start do |start_position|
      skip unless key = variable

      whitespace
      char '=', RecordFieldExpectedEqualSign
      whitespace

      value = expression! RecordFieldExpectedExpression

      Ast::RecordField.new(
        from: start_position,
        value: value,
        to: position,
        input: data,
        key: key)
    end
  end
end
