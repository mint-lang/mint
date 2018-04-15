class TypeChecker
  type_error TestTypeMismatch

  TEST_CONTEXT = Type.new("Test.Context", [Type.new("a")])

  def check(node : Ast::Test)
    type =
      check node.expression

    if Comparer.compare(type, BOOL) ||
       Comparer.compare(type, TEST_CONTEXT)
    else
      raise TestTypeMismatch, {
        "node" => node.expression,
      }
    end

    NEVER
  end
end
