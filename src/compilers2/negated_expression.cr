module Mint
  class Compiler2
    def compile(node : Ast::NegatedExpression) : Compiled
      compile node do
        [node.negations] + compile(node.expression)
      end
    end
  end
end
