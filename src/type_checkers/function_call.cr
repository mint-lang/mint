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
      type = check node.function

      if type.name == "Function"
        arguments =
          check node.arguments

        call_type =
          Type.new("Function", arguments + [type.parameters.last])

        if (type.parameters.size - 1) != node.arguments.size
          raise FunctionCallArgumentSizeMismatch, {
            "name"     => node.function.value,
            "got"      => call_type,
            "expected" => type,
            "node"     => node,
          }
        end

        resolved =
          Comparer.compare(type, call_type)

        raise FunctionCallArgumentTypeMismatch, {
          "got"      => call_type,
          "expected" => type,
          "node"     => node,
        } unless resolved
      else
        raise FunctionCallNotAFunction, {
          "name"   => node.function.value,
          "entity" => function,
          "node"   => node,
        }
      end

      resolve_type(resolved.parameters.last)
    end
  end
end
