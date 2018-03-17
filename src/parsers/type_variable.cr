class Parser
  def type_variable : Ast::TypeVariable | Nil
    return unless var = variable

    Ast::TypeVariable.new(
      value: var.value,
      from: var.from,
      input: data,
      to: var.to)
  end
end
