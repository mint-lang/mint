module Mint
  class TypeChecker
    type_error DocumentationDirectiveEntityNotFound

    def check(node : Ast::Directives::Documentation) : Checkable
      component =
        ast.components.find(&.name.==(node.entity))

      raise DocumentationDirectiveEntityNotFound, {
        "name" => node.entity,
        "node" => node,
      } unless component

      lookups[node] = component

      OBJECT
    end
  end
end
