module Mint
  class Compiler2
    def compile(node : Ast::UnaryMinus) : Compiled
      compile node do
        ["-("] + compile(node.expression) + [")"]
      end
    end
  end
end
