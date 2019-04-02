module Mint
  class TypeChecker
    type_error AccessCallArgumentSizeMismatch
    type_error AccessCallArgumentTypeMismatch
    type_error AccessCallNotAFunction
    type_error AccessCallTypeMismatch

    def check(node : Ast::AccessCall) : Checkable
      function_type =
        resolve node.access

      raise AccessCallNotAFunction, {
        "node" => node,
      } unless function_type.name == "Function"

      raise AccessCallArgumentSizeMismatch, {
        "size"      => (function_type.parameters.size - 1).to_s,
        "call_size" => node.arguments.size.to_s,
        "node"      => node,
      } unless (function_type.parameters.size - 1) == node.arguments.size

      call_parameters = [] of Checkable

      node.arguments.each_with_index do |argument, index|
        argument_type = function_type.parameters[index]
        call_argument = resolve argument

        raise AccessCallArgumentTypeMismatch, {
          "index"    => ordinal(index + 1),
          "expected" => argument_type,
          "got"      => call_argument,
          "node"     => node,
        } unless Comparer.compare(argument_type, call_argument)

        call_parameters << argument_type
      end

      call_type =
        Type.new("Function", call_parameters + [function_type.parameters.last])

      result =
        Comparer.compare(function_type, call_type)

      raise AccessCallTypeMismatch, {
        "expected" => function_type,
        "got"      => call_type,
        "node"     => node,
      } unless result

      function_type.parameters.last
    end
  end
end
