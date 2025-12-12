module Mint
  class TypeChecker
    def check(node : Ast::Context) : Checkable
      case defined_type = resolve(node.type)
      in Type, Record
        definition =
          ast.type_definitions.find(&.name.value.==(defined_type.name))

        error! :context_type_not_found do
          snippet "I was looking for a type for a context but I can't find it:", defined_type
          snippet "The context in question is here:", node
        end unless definition

        type =
          resolve definition

        lookups[node] = {definition, nil}

        error! :context_type_mismatch do
          block "The type of the context does not match its type definition."

          expected defined_type, type
          snippet "The context in question is here:", node
        end unless resolved = Comparer.compare(defined_type, type, expand: true)

        resolved
      in Variable
        error! :context_type_variable do
          snippet "The type of a context cannot be a type variable:", defined_type
          snippet "The context in question is here:", node
        end
      end
    end
  end
end
