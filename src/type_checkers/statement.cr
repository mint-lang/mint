module Mint
  class TypeChecker
    def check(node : Ast::Statement) : Checkable
      type =
        resolve node.expression

      type =
        if (node.await && type.name == "Promise") ||
           (node.await && type.name == "Deferred")
          type.parameters.first
        else
          type
        end

      required =
        case target = node.target
        when Ast::TupleDestructuring,
             Ast::ArrayDestructuring,
             Ast::TypeDestructuring,
             Ast::Discard
          case item = node.expression
          when Ast::Operation
            !item.right.is_a?(Ast::ReturnCall)
          else
            destructure(target, type)
            check_exhaustiveness(type, [target]).diagnostics.missing? &&
              !node.if_node
          end
        end

      error! :statement_return_required do
        block do
          text "This"
          bold "statement"
          text "needs a"
          bold "return call"
          text "because the destructuring is not exhaustive:"
        end

        snippet node
      end if required

      type
    end
  end
end
