class TypeChecker
  def check(node : Ast::CssSelector) : Type
    node.definitions.each { |item| check item }

    NEVER
  end
end
