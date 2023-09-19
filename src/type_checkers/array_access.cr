module Mint
  class TypeChecker
    def check(node : Ast::ArrayAccess) : Checkable
      index =
        node.index

      expression =
        node.expression

      type =
        resolve expression

      case index
      when Ast::NumberLiteral
        if type.name == "Tuple"
          parameter =
            type.parameters[index.value.to_i]?

          error! :array_access_invalid_tuple do
            snippet(
              "The tuple have only #{type.parameters.size} members, but " \
              "you wanted to access the #{ordinal(index.value.to_i + 1)}" \
              ". The exact type of the tuple is:", type)
            snippet "The tuple in question is here:", expression
          end unless parameter

          parameter
        else
          check_array_access(expression, type)
        end
      end || begin
        index_type =
          resolve index

        error! :array_access_index_not_number do
          block "The type of the index of an array access is not a number."
          expected NUMBER, index_type
          snippet "The index in question is here:", index
        end unless Comparer.compare(index_type, NUMBER)

        check_array_access(expression, type)
      end
    end

    def check_array_access(expression, type)
      error! :array_access_not_an_array do
        block "The entity you are trying to access an item from is not an " \
              "array or a tuple."
        expected "Array(a), Tuple(...)", type
        snippet "The array in question is here:", expression
      end unless resolved = Comparer.compare(type, ARRAY)

      Type.new("Maybe", [resolved.parameters.first] of Checkable)
    end
  end
end
