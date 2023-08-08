module Mint
  class TypeChecker
    def check(node : Ast::Directives::Documentation) : Checkable
      component =
        ast.components.find(&.name.value.==(node.entity.value))

      error! :documentation_directive_entity_not_found do
        snippet(
          "The entity for the documentation directive does not exist:",
          node.entity.value)

        snippet "The documentation directive in question is here:", node
      end unless component

      lookups[node] = {component, nil}

      OBJECT
    end
  end
end
