module Mint
  class Compiler
    def compile(node : TypeChecker::Type)
      parameters =
        node
          .parameters
          .map { |type| compile(type).as(String) }
          .join(",")

      "{ name: '#{node.name}', parameters: [#{parameters}] }"
    end

    def compile(node : Ast::CaseBranch, index : Int32) : String
      expression =
        compile node.expression

      if node.match
        matchNode = node.match

        condition =
          case matchNode
          when Ast::Type
            type =
              compile(types[matchNode])

            "_match(__condition, #{type})"
          else
            value =
              compile node.match.not_nil!

            "_compare(__condition, #{value})"
          end

        if index == 0
          <<-RESULT
          if (#{condition}) {
            return #{expression}
          }
          RESULT
        else
          <<-RESULT
          else if (#{condition}) {
            return #{expression}
          }
          RESULT
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
