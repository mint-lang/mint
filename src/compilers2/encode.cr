module Mint
  class Compiler2
    def compile(node : Ast::Encode) : Compiled
      code =
        encoder cache[node.expression]

      js.call(code, [compile(node.expression)])
    end
  end
end
