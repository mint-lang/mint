module Mint
  class Compiler
    def compile(node : Ast::CaseBranch, index : Int32) : String
      if checked.includes?(node)
        _compile node, index
      else
        ""
      end
    end

    def _compile(node : Ast::CaseBranch, index : Int32) : String
      expression =
        compile node.expression

      if match = node.match
        case match
        when Ast::EnumDestructuring
          variables =
            match.parameters.map_with_index do |param, index1|
              "const #{param.value} = __condition._#{index1}"
            end

          name =
            "$$#{underscorize(match.name)}_#{underscorize(match.option)}"

          <<-RESULT
            if (__condition instanceof #{name}) {
              #{variables.join("\n")}

              return #{expression}
            }
          RESULT
        else
          compiled =
            compile match

          if index == 0
            <<-RESULT
            if (_compare(__condition, #{compiled})) {
              return #{expression}
            }
            RESULT
          else
            <<-RESULT
            else if (_compare(__condition, #{compiled})) {
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
