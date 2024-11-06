module Mint
  class Compiler
    def compile(node : Ast::NegatedExpression) : Compiled
      compile node do
        [node.negations] + compile(node.expression)
      end
    end
  end
end
