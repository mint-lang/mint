module Mint
  class Compiler
    def compile(node : Ast::Case, block : Proc(String, String)? = nil) : String
      node.in?(checked) ? _compile(node, block) : ""
    end

    def _compile(node : Ast::Case, block : Proc(String, String)? = nil) : String
      condition = compile node.condition
      condition = "await #{condition}" if node.await

      branches =
        node
          .branches
          .sort_by(&.match.nil?.to_s)
          .map do |branch|
            _compile branch, block
          end

      js.call("_match", [condition, js.array(branches)])
    end
  end
end
