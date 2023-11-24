module Mint
  class Compiler2
    def compile(node : Ast::NegatedExpression) : Compiled
      expression =
        compile node.expression

      [node.negations] + expression
    end
  end
end
