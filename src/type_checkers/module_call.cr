class TypeChecker
  type_error ModuleCallArgumentSizeMismatch
  type_error ModuleCallArgumentTypeMismatch
  type_error ModuleCallNotFoundFunction
  type_error ModuleCallNotFoundModule
  type_error ModuleCallTypeMismatch

  def check(node : Ast::ModuleCall) : Type
    entity =
      ast.modules.find(&.name.==(node.name)) ||
        ast.stores.find(&.name.==(node.name))

    case entity
    when Ast::Module, Ast::Store
      function = entity.functions.find(&.name.value.==(node.function.value))

      raise ModuleCallNotFoundFunction, {
        "function" => node.function.value,
        "module"   => node.name,
        "node"     => node,
      } unless function

      raise ModuleCallArgumentSizeMismatch, {
        "function" => node.function.value,
        "module"   => node.name,
        "node"     => node,
      } if function.arguments.size != node.arguments.size

      Type.new("Function")

      parameters = [] of Type
      call_parameters = [] of Type

      function.arguments.each_with_index do |argument, index|
        call_argument = check node.arguments[index]
        argument_type = check argument

        raise ModuleCallArgumentTypeMismatch, {
          "function" => node.function.value,
          "argument" => argument.name.value,
          "module"   => node.name,
          "snippet"  => function,
          "node"     => node,
          "expected" => argument_type,
          "got"      => call_argument,
        } unless Comparer.compare(argument_type, call_argument)

        call_parameters << call_argument
        parameters << argument_type
      end

      return_type = check(function.type)

      function_type = Type.new("Function", parameters + [return_type])
      call_type = Type.new("Function", call_parameters + [return_type])

      result = Comparer.compare(function_type, call_type)

      raise ModuleCallTypeMismatch, {
        "function" => node.function.value,
        "expected" => function_type,
        "module"   => node.name,
        "got"      => call_type,
        "node"     => node,
      } unless result

      resolve_type(result.parameters.last)
    else
      raise ModuleCallNotFoundModule, {
        "name" => node.name,
        "node" => node,
      }
    end
  end
end
