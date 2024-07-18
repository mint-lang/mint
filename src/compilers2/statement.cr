module Mint
  class Compiler2
    def compile(node : Ast::Statement) : Compiled
      compile node do
        right, return_call =
          case expression = node.expression
          when Ast::Operation
            case item = expression.right
            when Ast::ReturnCall
              {
                compile(expression.left),
                compile(item.expression),
              }
            end
          end || {compile(node.expression), nil}

        right = ([Await.new, " "] of Item) + defer(node.expression, right) if node.await

        if target = node.target
          case target
          when Ast::Variable
            js.const(target, right)
          when Ast::TupleDestructuring,
               Ast::ArrayDestructuring,
               Ast::TypeDestructuring,
               Ast::Discard
            variables = [] of Compiled

            pattern =
              destructuring(target, variables)

            case target
            when Ast::TupleDestructuring
              if target.items.all?(Ast::Variable)
                js.const(js.array(variables), right)
              end
            end || begin
              var =
                Variable.new

              const =
                js.const(var, js.call(Builtin::Destructure, [right, pattern]))

              return_if =
                if return_call
                  js.if([var, " === false"], js.return(return_call))
                end

              js.statements([
                const,
                return_if,
                js.const(js.array(variables), [var]),
              ].compact)
            end
          end
        end || right
      end
    end
  end
end
