module Mint
  class Compiler
    def _compile(node : Ast::Case) : String
      condition =
        compile node.condition

      condition_let =
        "let __condition = #{condition}\n\n"

      body =
        node
          .branches
          .sort_by(&.match.nil?.to_s)
          .map_with_index { |branch, index| compile branch, index }
          .reduce(condition_let) { |memo, branch| memo + " " + branch }

      <<-RESULT
      (() => {
      #{body.indent}
      })()
      RESULT
    end
  end
end
