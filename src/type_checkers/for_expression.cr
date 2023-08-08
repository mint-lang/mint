module Mint
  class TypeChecker
    def check(node : Ast::For) : Checkable
      subject =
        resolve node.subject

      is_array_or_set =
        Comparer.compare(ARRAY, subject) || Comparer.compare(SET, subject)

      is_map =
        Comparer.compare(MAP, subject)

      is_valid =
        is_array_or_set || is_map

      error! :for_type_mismatch do
        block "The iterable object of a for expression has an invalid type."
        block "I was expecting one of the following types:"

        snippet "Array(a), Set(a), Map(a, b)"
        snippet "Instead it is:", subject
        snippet "The iterable object in question is here:", node.subject
      end unless is_valid

      error! :for_map_arguments_mismatch do
        snippet "If the iterable object of a for expression is a map, then " \
                "it needs to the have 2 arguments:", node.arguments.first
      end if is_map && !node.arguments.size.in?(2, 3)

      error! :for_array_or_set_arguments_mismatch do
        snippet(
          "If the iterable object of a for expression is a set or an " \
          "array. Then it needs to the have only 1 argument:",
          node.arguments.first)
      end if is_array_or_set && !node.arguments.size.in?(1, 2)

      node
        .arguments
        .each_with_index do |argument, index|
          if (is_map && index == 2) || (is_array_or_set && index == 1)
            cache[argument] = NUMBER

            scope.add(node, argument.value, argument)
          else
            cache[argument] = subject.parameters[index]

            scope.add(node, argument.value, argument)
          end
        end

      type = begin
        node.condition.try do |condition|
          condition_type = resolve condition

          error! :for_condition_type_mismatch do
            snippet "The condition of a for expression has an invalid type. " \
                    "I was expecting:", BOOL

            snippet "Instead it is:", condition_type
            snippet "The value in question is here:", condition.expressions.last
          end unless Comparer.compare(BOOL, condition_type)
        end

        resolve node.body
      end

      Type.new("Array", [type])
    end
  end
end
