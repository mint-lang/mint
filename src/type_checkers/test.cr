class TypeChecker
  type_error TestTypeMismatch

  SPEC_CONTEXT = Type.new("Spec.Context", [Type.new("a")])

  def check(node : Ast::Test)
    type =
      check node.expression

    if Comparer.compare(type, BOOL) ||
       Comparer.compare(type, SPEC_CONTEXT)
    else
      raise TestTypeMismatch, {
        "node" => node.expression,
      }
    end

    NEVER
  end
end
