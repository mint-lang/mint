module Mint
  class Formatter
    def format(node : Ast::NumberLiteral) : Nodes
      format(node.value)
    end
  end
end
