module Mint
  class Compiler
    def compile(node : Ast::ParenthesizedExpression) : Compiled
      compile node do
        ["("] + compile(node.expression) + [")"]
      end
    end
  end
end
