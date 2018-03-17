class TypeChecker
  def check(node : Ast::Style) : Type
    check node.definitions
    check node.selectors

    NEVER
  end
end
