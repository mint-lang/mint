module Mint
  class Compiler
    def compile(
      node : Ast::Case,
      block : Proc(String, String)? = nil
    ) : Compiled
      compile node do
        condition =
          compile node.condition

        branches =
          node
            .branches
            .sort_by(&.pattern.nil?.to_s)
            .map { |branch| compile branch, block }

        if node.await
          variable =
            Variable.new

          js.iif do
            js.statements([
              js.let(variable, ([Await.new, " "] of Item) + defer(node.condition, condition)),
              js.return(js.call(Builtin::Match, [
                [variable] of Item,
                js.array(branches),
              ])),
            ])
          end
        else
          js.call(Builtin::Match, [condition, js.array(branches)])
        end
      end
    end
  end
end
