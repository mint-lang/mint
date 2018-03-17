class TypeChecker
  type_error WithNotFoundModule

  def check(node : Ast::With) : Type
    entity =
      ast.modules.find(&.name.==(node.name))

    raise WithNotFoundModule, {
      "name" => node.name,
      "node" => node,
    } unless entity

    scope entity do
      check node.body
    end
  end
end
