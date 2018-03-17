class TypeChecker
  type_error VariableMissing

  def check(node : Ast::Variable) : Type
    item = loopkup_with_level(node)

    raise VariableMissing, {
      "name" => node.value,
      "node" => node,
    } unless item

    variables[node] = item

    check item[0]
  end
end
