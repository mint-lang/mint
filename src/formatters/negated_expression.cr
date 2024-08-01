module Mint
  class Formatter
    def format(node : Ast::NegatedExpression) : Nodes
      expression =
        format node.expression

      [node.negations] + expression
    end
  end
end
