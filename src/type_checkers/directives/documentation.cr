module Mint
  class TypeChecker
    type_error DocumentationDirectiveEntityNotFound

    def check(node : Ast::Directives::Documentation) : Checkable
      component =
        ast.components.find(&.name.value.==(node.entity.value))

      raise DocumentationDirectiveEntityNotFound, {
        "name" => node.entity.value,
        "node" => node,
      } unless component

      lookups[node] = component

      OBJECT
    end
  end
end
