module Mint
  class Compiler
    def compile(node : Ast::Case, block : Proc(String, String)? = nil) : String
      if checked.includes?(node)
        _compile node, block
      else
        ""
      end
    end

    def _compile(node : Ast::Case, block : Proc(String, String)? = nil) : String
      condition = compile node.condition
      condition = "await #{condition}" if node.await

      variable, condition_let =
        js.let condition

      body =
        node
          .branches
          .sort_by(&.match.nil?.to_s)
          .map_with_index do |branch, index|
            _compile branch, index, variable, block
          end

      if node.await
        js.asynciif do
          js.statements([condition_let, js.ifchain(body)])
        end
      else
        js.iif do
          js.statements([condition_let, js.ifchain(body)])
        end
      end
    end
  end
end
