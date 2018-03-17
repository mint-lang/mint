class TypeChecker
  def check(node : Ast::Where) : Type
    check node.expression
  end
end
