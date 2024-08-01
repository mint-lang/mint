module Mint
  class Formatter
    def format(node : Ast::Spread) : Nodes
      ["..."] + format(node.variable)
    end
  end
end
