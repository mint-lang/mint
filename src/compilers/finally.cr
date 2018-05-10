module Mint
  class Compiler
    def compile(node : Ast::Finally) : String
      body =
        compile node.expression

      "finally {\n#{body}\n}"
    end
  end
end
