class TypeChecker
  type_error TestTypeMismatch

  def check(node : Ast::Test)
    type =
      check node.expression

    raise TestTypeMismatch, {
      "node" => node.expression,
    } unless Comparer.compare(type, BOOL)

    NEVER
  end
end
