module Mint
  class Compiler
    def _compile(node : Ast::Finally) : Codegen::Node
      body =
        compile node.expression

      Codegen.join ["finally {\n", Codegen.indent(body), "\n}"]
    end
  end
end
