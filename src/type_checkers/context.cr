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

      error! :context_not_record do
        snippet "The type of a context is not a record:", type
        snippet "The context in question is here:", node
        snippet "The type is defined here:", definition
      end unless type.is_a?(Record)

      lookups[node] = {definition, nil}

      type
    end
  end
end
