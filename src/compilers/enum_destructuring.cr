module Mint
  class Compiler
    def _compile(node : Ast::EnumDestructuring, variable : String) : Tuple(String, Array(String))
      variables =
        case lookups[node].as(Ast::EnumOption).parameters[0]?
        when Ast::EnumRecordDefinition
          node.parameters.compact_map do |param|
            case param
            when Ast::TypeVariable
              "const #{js.variable_of(param)} = #{variable}._0.#{param.value}"
            end
          end
        else
          node.parameters.map_with_index do |param, index1|
            "const #{js.variable_of(param)} = #{variable}._#{index1}"
          end
        end

      name =
        js.class_of(lookups[node])

      {
        "#{variable} instanceof #{name}",
        variables,
      }
    end
  end
end
