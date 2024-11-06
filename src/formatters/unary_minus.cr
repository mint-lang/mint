module Mint
  class Formatter
    def format(node : Ast::UnaryMinus) : Nodes
      ["-"] + format(node.expression)
    end
  end
end
