module Mint
  class TypeChecker
    type_error ForArrayOrSetArgumentsMismatch
    type_error ForConditionTypeMismatch
    type_error ForMapArgumentsMismatch
    type_error ForTypeMismatch

    def check(node : Ast::For) : Checkable
      subject =
        resolve node.subject

      is_array_or_set =
        Comparer.compare(ARRAY, subject) || Comparer.compare(SET, subject)

      is_map =
        Comparer.compare(MAP, subject)

      is_valid =
        is_array_or_set || is_map

      raise ForTypeMismatch, {
        "node" => node,
        "got"  => subject,
      } unless is_valid

      raise ForMapArgumentsMismatch, {
        "node" => node,
      } if is_map && !node.arguments.size.in?(2, 3)

      raise ForArrayOrSetArgumentsMismatch, {
        "node" => node,
      } if is_array_or_set && !node.arguments.size.in?(1, 2)

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

          raise ForConditionTypeMismatch, {
            "node"     => condition,
            "got"      => condition_type,
            "expected" => BOOL,
          } unless Comparer.compare(BOOL, condition_type)
        end

        resolve node.body
      end

      Type.new("Array", [type])
    end
  end
end
