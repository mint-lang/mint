module Mint
  class Compiler
    def compile(node : Ast::Case, block : Proc(String, String)? = nil) : String
      node.in?(checked) ? _compile(node, block) : ""
    end

    def _compile(node : Ast::Case, block : Proc(String, String)? = nil) : String
      condition = compile node.condition
      condition = "await #{condition}" if node.await

      variable, _ =
        js.let condition

      body =
        node
          .branches
          .sort_by(&.match.nil?.to_s)
          .map_with_index do |branch, index|
            _compile branch, index, variable, block
          end

      x =
        body.map { |(a, b)| js.array([a || "null", b || "null"]) }

      js.call("_match", [condition, js.array(x)])
    end
  end
end
