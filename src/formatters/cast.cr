module Mint
  class Formatter
    def format(node : Ast::Cast) : Nodes
      format(node.expression) + [" cast "] + format(node.type)
    end
  end
end
