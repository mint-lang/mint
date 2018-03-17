class TypeChecker
  type_error GetTypeMismatch

  def check(node : Ast::Get) : Type
    scope node do
      body_type =
        check node.body

      return_type =
        check node.type

      raise GetTypeMismatch, {
        "expected" => return_type,
        "got"      => body_type,
        "node"     => node,
      } unless Comparer.compare(body_type, return_type)

      return_type
    end
  end
end
