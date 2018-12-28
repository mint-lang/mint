module Mint
  class Compiler
    def _compile(node : Ast::Catch) : String
      body =
        compile node.expression

      variable =
        node.variable.value

      js.statements([
        js.let(variable, "_error"),
        js.assign("_", body),
        "throw new DoError()",
      ])
    end
  end
end
