module Mint
  class Compiler2
    def compile(node : Ast::Case, block : Proc(String, String)? = nil) : Compiled
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

        let =
          js.let(variable, ["await "] + condition)

        js.asynciif do
          js.statements([
            let,
            js.return(js.call(Builtin::Match, [[variable] of Item, js.array(branches)])),
          ])
        end
      else
        js.call(Builtin::Match, [condition, js.array(branches)])
      end
    end
  end
end
