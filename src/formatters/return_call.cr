module Mint
  class Formatter
    def format(node : Ast::ReturnCall) : Nodes
      ["return "] + format(node.expression)
    end
  end
end
