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

      error :for_type_mismatch do
        block "The iterable object of a for expression has an invalid type."
        block "I was expecting one of the following types:"

        snippet "Array(a), Set(a), Map(a, b)"
        snippet "Instead it is:", subject
        snippet node
      end unless is_valid

      error :for_map_arguments_mismatch do
        block do
          text "If the iterable object of a for expression is a map."
          text "Then it needs to the have two arguments."
        end

        snippet node
      end if is_map && !node.arguments.size.in?(2, 3)

      error :for_array_or_set_arguments_mismatch do
        block do
          text "If the iterable object of a for expression is a set or an array."
          text "Then it needs to the have only one argument."
        end

        snippet node
      end if is_array_or_set && !node.arguments.size.in?(1, 2)

      arguments =
        node
          .arguments
          .each_with_index
          .reduce([] of Tuple(String, Checkable, Ast::Node)) do |memo, (argument, index)|
            memo << if (is_map && index == 2) || (is_array_or_set && index == 1)
              {argument.value, NUMBER, argument}
            else
              {argument.value, subject.parameters[index], argument}
            end
          end

      type = scope(arguments) do
        node.condition.try do |condition|
          condition_type = resolve condition

          error :for_condition_type_mismatch do
            block "The condition of a for expression has an invalid type."
            expected BOOL, condition_type

            snippet condition
          end unless Comparer.compare(BOOL, condition_type)
        end

        resolve node.body
      end

      Type.new("Array", [type])
    end
  end
end
