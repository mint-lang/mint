module Mint
  class Compiler2
    def compile(node : Ast::Constant) : Compiled
      js.const(node, compile(node.expression))
    end
  end
end
