module Mint
  class Formatter
    def format(node : Ast::Encode) : Nodes
      ["encode "] + format(node.expression)
    end
  end
end
