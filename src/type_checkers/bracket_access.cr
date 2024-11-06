module Mint
  class TypeChecker
    def check(node : Ast::BracketAccess) : Checkable
      index, expression =
        node.index, node.expression

      type =
        resolve expression

      index_type =
        resolve index

      if type.name == "Tuple"
        case index
        when Ast::NumberLiteral
          error! :bracket_access_invalid_tuple_index do
            block "The index of an array access for a tuple is a float, " \
                  "it can be only integer."
            snippet "The access in question is here:", node
          end if index.float?

          parameter =
            type.parameters[index.value.to_i]?

          error! :bracket_access_invalid_tuple do
            snippet "The tuple has only #{type.parameters.size} members, but " \
                    "you wanted to access the #{ordinal(index.value.to_i + 1)}" \
                    ". The exact type of the tuple is:", type
            snippet "The tuple in question is here:", expression
          end unless parameter

          parameter
        else
          error! :bracket_access_invalid_tuple_access do
            snippet "Tuples do not support non integer access:", index
            snippet "The tuple in question is here:", expression
          end
        end
      elsif type.name == "Map" && type.parameters.size == 2
        error! :bracket_access_index_not_map_key do
          block "The type of the index of a bracket access does not match the type of the keys."
          expected type.parameters.first, type.parameters.first
          snippet "The index in question is here:", index
        end unless Comparer.compare(type.parameters.first, index_type)

        Type.new("Maybe", [type.parameters.last] of Checkable)
      elsif type.name == "Array" && type.parameters.size == 1
        error! :bracket_access_index_not_number do
          block "The type of the index of a bracket access is not a number."
          expected NUMBER, index_type
          snippet "The index in question is here:", index
        end unless Comparer.compare(index_type, NUMBER)

        Type.new("Maybe", [type.parameters.first] of Checkable)
      else
        error! :bracket_access_not_accessible do
          block "The entity you are trying to access an item from is not an " \
                "array, map or a tuple."
          expected "Array(a), Map(a, b) or Tuple(...)", type
          snippet "The array in question is here:", expression
        end
      end
    end
  end
end
