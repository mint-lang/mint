module Mint
  class Formatter
    def format(node : Ast::Await) : Nodes
      ["await "] + format(node.body)
    end
  end
end
