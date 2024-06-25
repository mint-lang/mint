module Mint
  class Formatter2
    def format(node : Ast::Spread) : Nodes
      ["..."] + format(node.variable)
    end
  end
end
