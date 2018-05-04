module Mint
  class Compiler
    def compile(node : Ast::Catch) : String
      body =
        compile node.expression

      variable =
        node.variable.value

      "let #{variable} = _error;\n #{body}"
    end
  end
end
