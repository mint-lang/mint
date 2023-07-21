module Mint
  class TypeChecker
    type_error CallArgumentSizeMismatch
    type_error CallArgumentTypeMismatch
    type_error CallNotFoundArgument
    type_error CallMixedArguments
    type_error CallTypeMismatch
    type_error CallNotAFunction

    def check(node : Ast::CallExpression)
      resolve(node.expression).tap do |item|
        item.label = node.name.try(&.value)
      end
    end

    def check(node : Ast::Call)
      function_type =
        resolve node.expression

      check_call(node, function_type)
    end

    def check_call(node, function_type) : Checkable
      raise CallNotAFunction, {
        "node" => node,
      } unless function_type.name == "Function"

      argument_size =
        function_type.parameters.size - 1

      required_argument_size =
        case function_type
        when TypeChecker::Type
          argument_size - function_type.optional_count
        else
          argument_size
        end

      parameters =
        [] of Checkable

      raise CallArgumentSizeMismatch, {
        "call_size" => node.arguments.size.to_s,
        "size"      => argument_size.to_s,
        "node"      => node,
      } if node.arguments.size > argument_size ||       # If it's more than the maximum
           node.arguments.size < required_argument_size # If it's less then the minimum

      if node.arguments.all?(&.name.nil?)
        node.arguments
      elsif node.arguments.all?(&.name.!=(nil))
        node.arguments.sort_by! do |argument|
          index =
            function_type
              .parameters
              .index { |param| param.label == argument.name.try(&.value) }

          raise CallNotFoundArgument, {
            "name" => argument.name.try(&.value).to_s,
            "node" => node,
          } unless index

          index
        end
      else
        raise CallMixedArguments, {
          "node" => node,
        }
      end

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

      if (optional_param_count = argument_size - node.arguments.size) > 0
        parameters.concat(function_type.parameters[node.arguments.size, optional_param_count])
      end

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
