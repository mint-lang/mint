module Mint
  class TypeChecker
    type_error ModuleCallArgumentSizeMismatch
    type_error ModuleCallArgumentTypeMismatch
    type_error ModuleCallNotFoundFunction
    type_error ModuleCallNotFoundModule
    type_error ModuleCallTypeMismatch

    def check(node : Ast::ModuleCall) : Checkable
      entity =
        ast.modules.find(&.name.==(node.name)) ||
          ast.stores.find(&.name.==(node.name))

      case entity
      when Ast::Module, Ast::Store
        checked.add(entity)

        function = entity.functions.find(&.name.value.==(node.function.value))

        raise ModuleCallNotFoundFunction, {
          "name"        => node.function.value,
          "module_name" => node.name,
          "node"        => node,
        } unless function

        raise ModuleCallArgumentSizeMismatch, {
          "size"      => function.arguments.size.to_s,
          "call_size" => node.arguments.size.to_s,
          "name"      => node.function.value,
          "function"  => function,
          "node"      => node,
        } if function.arguments.size != node.arguments.size

        parameters = [] of Checkable
        call_parameters = [] of Checkable

        function.arguments.each_with_index do |argument, index|
          call_argument = resolve node.arguments[index]
          argument_type = resolve argument

          raise ModuleCallArgumentTypeMismatch, {
            "index"    => ordinal(index + 1),
            "expected" => argument_type,
            "got"      => call_argument,
            "function" => function,
            "node"     => node,
          } unless Comparer.compare(argument_type, call_argument)

          call_parameters << call_argument
          parameters << argument_type
        end

        return_type =
          resolve function.type

        function_type =
          resolve function

        call_type =
          Type.new("Function", call_parameters + [return_type])

        result =
          Comparer.compare(function_type, call_type)

        raise ModuleCallTypeMismatch, {
          "expected" => function_type,
          "got"      => call_type,
          "function" => function,
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
end
