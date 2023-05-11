module Mint
  class TypeChecker
    def check(node : Ast::Statement, check_return : Bool = true) : Checkable
      type =
        if check_return
          case node.target
          # TODO: Check tuple destructuring...
          when Ast::EnumDestructuring, Ast::ArrayDestructuring
            # TODO: Create error citing need to return
            raise TypeError.new unless node.return?

            case expression = node.expression
            when Ast::Operation
              if expression.operator == "or" && expression.right.is_a?(Ast::ReturnCall)
                # Resolve the retuned expression so it can be used later
                resolve expression.right.as(Ast::ReturnCall).expression
                resolve expression.left
              end
            end
          end
        end || resolve node.expression

      type =
        type.parameters.first if node.await && type.name == "Promise"

      types[node] = type
    end
  end
end
