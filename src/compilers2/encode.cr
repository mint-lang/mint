module Mint
  class Compiler2
    def compile(node : Ast::Encode) : Compiled
      compile node do
        code =
          encoder cache[node.expression]

        js.call(code, [compile(node.expression)])
      end
    end
  end
end
