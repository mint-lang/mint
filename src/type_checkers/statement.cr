module Mint
  class TypeChecker
    def check(node : Ast::Statement) : Checkable
      type =
        resolve node.expression

      required =
        case target = node.target
        when Ast::TupleDestructuring,
             Ast::ArrayDestructuring,
             Ast::TypeDestructuring,
             Ast::Discard
          destructure(target, type)

          if node.if_node
            false
          else
            check_exhaustiveness(type, [target]).diagnostics.missing? &&
              !node.return_value
          end
        end

      node.return_value.try(&->resolve(Ast::Node))

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
