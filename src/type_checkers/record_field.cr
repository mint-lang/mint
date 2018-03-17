class TypeChecker
  def check(node : Ast::RecordField) : Type
    check node.value
  end
end
