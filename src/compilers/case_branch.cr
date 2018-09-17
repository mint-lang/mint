module Mint
  class Compiler
    def compile(node : Ast::CaseBranch, index : Int32, variable : String) : String
      expression =
        compile node.expression

      if match = node.match
        case match
        when Ast::EnumDestructuring
          variables =
            match.parameters.map_with_index do |param, index1|
              "const #{param.value} = #{variable}._#{index1}"
            end

          name =
            "$$#{underscorize(match.name)}_#{underscorize(match.option)}"

          <<-RESULT
            if (#{variable} instanceof #{name}) {
              #{variables.join("\n")}

              return #{expression}
            }
          RESULT
        else
          compiled =
            compile match

          if index == 0
            <<-RESULT
            if (_compare(#{variable}, #{compiled})) {
              return #{expression}
            }
            RESULT
          else
            <<-RESULT
            else if (_compare(#{variable}, #{compiled})) {
              return #{expression}
            }
            RESULT
          end
        end
      else
        <<-RESULT
        else {
          return #{expression}
        }
        RESULT
      end
    end
  end
end
