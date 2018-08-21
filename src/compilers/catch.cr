module Mint
  class Compiler
    def _compile(node : Ast::Catch) : String
      body =
        compile node.expression

      variable =
        node.variable.value

      "let #{variable} = _error;\n\n _result = #{body}\n\nthrow new DoError()"
    end
  end
end
