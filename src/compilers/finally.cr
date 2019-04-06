module Mint
  class Compiler
    def _compile(node : Ast::Finally) : String
      body =
        compile node.expression

      "finally {\n#{body.indent}\n}"
    end
  end
end
