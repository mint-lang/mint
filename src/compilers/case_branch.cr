module Mint
  class Compiler
    def compile(node : Ast::CaseBranch, index : Int32) : String
      expression =
        compile node.expression

      if match = node.match
        case match
        when Ast::EnumDestructuring
          variables =
            match.parameters.map_with_index do |param, index|
              "const #{param.value} = __condition._#{index}"
            end
              .join("\n")

          name =
            "$$#{underscorize(match.name)}_#{underscorize(match.option)}"

          <<-RESULT
            if (__condition instanceof #{name}) {
              #{variables}

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
