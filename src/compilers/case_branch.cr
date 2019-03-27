module Mint
  class Compiler
    def compile(node : Ast::CaseBranch, index : Int32, variable : String) : String
      if checked.includes?(node)
        _compile node, index, variable
      else
        ""
      end
    end

    def _compile(node : Ast::CaseBranch, index : Int32, variable : String) : String
      expression =
        compile node.expression

      if match = node.match
        case match
        when Ast::EnumDestructuring
          variables =
            match.parameters.map_with_index do |param, index1|
              "const #{js.variable_of(param)} = #{variable}._#{index1}"
            end

          name =
            js.class_of(lookups[match])

          js.if("#{variable} instanceof #{name}") do
            js.statements(variables + [js.return(expression)])
          end
        else
          compiled =
            compile match

          if index == 0
            js.if("_compare(#{variable}, #{compiled})") do
              js.return(expression)
            end
          else
            js.elseif("_compare(#{variable}, #{compiled})") do
              js.return(expression)
            end
          end
        end
      else
        js.else do
          js.return(expression)
        end
      end
    end
  end
end
