module Mint
  class TypeChecker
    def check(node : Ast::Directives::Documentation) : Checkable
      component =
        ast.components.find(&.name.value.==(node.entity.value))

      error :documentation_directive_entity_not_found do
        block do
          text "The entity for the documentation directive:"
          code node.entity.value
          text "does not exists."
        end

        snippet node
      end unless component

      lookups[node] = component

      OBJECT
    end
  end
end
