module Mint
  class Compiler
    def _compile(node : Ast::Case) : String
      condition =
        compile node.condition

      variable, condition_let =
        js.let condition

      body =
        node
          .branches
          .sort_by(&.match.nil?.to_s)
          .map_with_index { |branch, index| compile branch, index, variable }

      js.iif body: js.statements([condition_let] + body)
    end
  end
end
