module Mint
  class TypeChecker
    def check(node : Ast::Context) : Checkable
      name =
        node.type.value

      definition =
        ast.type_definitions.find(&.name.value.==(name))

      error! :context_type_not_found do
        snippet "I was looking for a type for a context but I can't find it:", name
        snippet "The context in question is here:", node
      end unless definition

      type =
        resolve definition

      lookups[node] = {definition, nil}

      type
    end
  end
end
