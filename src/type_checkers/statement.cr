module Mint
  class TypeChecker
    type_error StatementReturnRequired

    def check(node : Ast::Statement) : Checkable
      case target = node.target
      when Ast::TupleDestructuring,
           Ast::ArrayDestructuring,
           Ast::EnumDestructuring
        case item = node.expression
        when Ast::Operation
          raise StatementReturnRequired, {
            "node" => node,
          } unless item.right.is_a?(Ast::ReturnCall)
        else
          unless target.exhaustive?
            raise StatementReturnRequired, {
              "node" => node,
            } unless node.if_node
          end
        end
      end

      type =
        resolve node.expression

      type =
        type.parameters.first if node.await && type.name == "Promise"

      types[node] = type
    end
  end
end
