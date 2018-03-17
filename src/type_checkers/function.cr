class TypeChecker
  type_error FunctionTypeMismatch

  def check(node : Ast::Function) : Type
    scope node do
      body_type =
        check node.body

      return_type =
        check node.type

      arguments =
        check node.arguments

      wheres =
        check node.wheres

      resolved =
        Comparer.compare(body_type, return_type)

      raise FunctionTypeMismatch, {
        "expected" => return_type,
        "got"      => body_type,
        "node"     => node,
      } unless resolved

      Type.new("Function", arguments + [return_type])
    end
  end
end
