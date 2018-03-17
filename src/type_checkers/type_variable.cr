class TypeChecker
  def check(node : Ast::TypeVariable) : Type
    Type.new(node.value)
  end
end
