module Mint
  class TypeChecker
    type_error EnumNotDefinedParameter
    type_error EnumUnusedParameter

    def check(node : Ast::Enum) : Checkable
      check_global_types node.name, node

      parameters =
        resolve node.parameters

      used_parameters = Set(Ast::TypeVariable).new

      node.options.each do |option|
        check option.parameters, node.parameters, used_parameters
      end

      node.parameters.each do |parameter|
        raise EnumUnusedParameter, {
          "name" => parameter.value,
          "node" => parameter,
        } unless used_parameters.includes?(parameter)
      end

      Type.new(node.name, parameters)
    end

    def check(parameters : Array(Ast::Node),
              names : Array(Ast::TypeVariable),
              used_parameters : Set(Ast::TypeVariable))
      parameters.each do |parameter|
        case parameter
        when Ast::Type
          check parameter.parameters, names, used_parameters
        when Ast::TypeVariable
          param =
            names.find(&.value.==(parameter.value))

          raise EnumNotDefinedParameter, {
            "name" => parameter.value,
            "node" => parameter,
          } unless param

          used_parameters.add param
        end
      end
    end
  end
end
