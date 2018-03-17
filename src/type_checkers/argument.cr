class TypeChecker
  def check(node : Ast::Argument) : Type
    check node.type
  end
end
