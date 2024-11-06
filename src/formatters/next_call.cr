module Mint
  class Formatter
    def format(node : Ast::NextCall) : Nodes
      ["next "] + format(node.data)
    end
  end
end
