module Mint
  class Formatter
    def format(node : Ast::ParenthesizedExpression) : Nodes
      ["("] + format(node.expression) + [")"]
    end
  end
end
