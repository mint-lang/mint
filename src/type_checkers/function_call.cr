module Mint
  class TypeChecker
    type_error FunctionCallArgumentSizeMismatch
    type_error FunctionCallArgumentTypeMismatch
    type_error FunctionCallNotFoundFunction
    type_error FunctionCallNotAFunction

    def check(node : Ast::FunctionCall) : Type
      function = loopkup node.function

      case function
      when Nil
        raise FunctionCallNotFoundFunction, {
          "name" => node.function.value,
          "node" => node,
        }
      else
        type = resolve node.function

        if type.name == "Function"
          arguments =
            resolve node.arguments

          call_type =
            Type.new("Function", arguments + [type.parameters.last])

          raise FunctionCallArgumentSizeMismatch, {
            "name"     => node.function.value,
            "got"      => call_type,
            "function" => function,
            "expected" => type,
            "node"     => node,
          } if (type.parameters.size - 1) != node.arguments.size

          arguments.each_with_index do |argument, index|
            original =
              type.parameters[index]

            raise FunctionCallArgumentTypeMismatch, {
              "index"    => ordinal(index + 1),
              "got"      => argument,
              "expected" => original,
              "function" => function,
              "node"     => node,
            } unless Comparer.compare(argument, original)
          end
        else
          raise FunctionCallNotAFunction, {
            "name"     => node.function.value,
            "function" => function,
            "node"     => node,
          }
        end

        resolve_type(type.parameters.last)
      end
    end
  end
end
