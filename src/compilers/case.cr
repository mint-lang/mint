module Mint
  class Compiler
    def compile(node : Ast::Case, block : Proc(String, String)? = nil) : String
      node.in?(checked) ? _compile(node, block) : ""
    end

    def _compile(node : Ast::Case, block : Proc(String, String)? = nil) : String
      condition = compile node.condition

      branches =
        node
          .branches
          .sort_by(&.pattern.nil?.to_s)
          .map do |branch|
            _compile branch, block
          end

      if node.await
        variable, condition_let =
          js.let "await #{condition}"

        js.asynciif do
          js.statements([
            condition_let,
            js.return(js.call("_match", [variable, js.array(branches)])),
          ])
        end
      else
        js.call("_match", [condition, js.array(branches)])
      end
    end
  end
end
