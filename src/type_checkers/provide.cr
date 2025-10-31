module Mint
  class TypeChecker
    def check(node : Ast::Provide) : Checkable
      type =
        ast.type_definitions.find(&.name.value.==(node.name.value))

      error! :provide_not_found_type do
        snippet "I could not find a type:", node.name
      end unless type

      lookups[node] = {type, nil}

      type =
        resolve type

      expression_type =
        resolve node.expression

      resolved =
        Comparer.compare(expression_type, type)

      error! :provide_type_mismatch do
        block "The type of a provide does not match its definition."
        expected type, expression_type
        snippet "The provide in question is here:", node
      end unless resolved

      resolved
    end
  end
end
