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
      } if is_map && node.arguments.size != 2

      raise ForArrayOrSetArgumentsMismatch, {
        "node" => node,
      } if is_array_or_set && node.arguments.size != 1

      arguments =
        node
          .arguments
          .each_with_index
          .reduce([] of Tuple(String, Checkable, Ast::Node)) do |memo, (argument, index)|
            memo << {argument.value, subject.parameters[index], argument}
          end

      type = scope(arguments) do
        node.condition.try do |condition|
          condition_type = resolve condition.condition

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
