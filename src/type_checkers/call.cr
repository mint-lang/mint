module Mint
  class TypeChecker
    type_error CallArgumentSizeMismatch
    type_error CallArgumentTypeMismatch
    type_error CallTypeMismatch
    type_error CallNotAFunction

    def check(node : Ast::Call)
      function_type =
        resolve node.expression

      raise CallNotAFunction, {
        "node" => node,
      } unless function_type.name == "Function"

      argument_size = function_type.parameters.size - 1
      parameters = [] of Checkable

      raise CallArgumentSizeMismatch, {
        "node" => node,
      } if node.arguments.size > argument_size

      node.arguments.each_with_index do |argument, index|
        argument_type =
          resolve argument

        function_argument_type =
          function_type.parameters[index]

        raise CallArgumentTypeMismatch, {
          "index"    => ordinal(index + 1),
          "expected" => function_argument_type,
          "got"      => argument_type,
          "function" => function_type,
          "node"     => node,
        } unless Comparer.compare(function_argument_type, argument_type)

        parameters << argument_type
      end

      # This is a partial application
      if node.arguments.size < argument_size
        range =
          (node.arguments.size..function_type.parameters.size)

        call_type =
          Type.new("Function", parameters + function_type.parameters[range])

        unified_type =
          Comparer.compare(function_type, call_type)

        raise CallTypeMismatch, {
          "expected" => function_type,
          "got"      => call_type,
          "node"     => node,
        } unless unified_type

        node.partially_applied = true

        Type.new("Function", unified_type.parameters[range])
      else # This is a full call
        call_type =
          Type.new("Function", parameters + [function_type.parameters.last])

        result =
          Comparer.compare(function_type, call_type)

        raise CallTypeMismatch, {
          "expected" => function_type,
          "got"      => call_type,
          "node"     => node,
        } unless result

        resolve_type(result.parameters.last)
      end
    end
  end
end
