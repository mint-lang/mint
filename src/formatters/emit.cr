module Mint
  class Formatter
    def format(node : Ast::Emit) : Nodes
      ["emit "] + format(node.expression)
    end
  end
end
