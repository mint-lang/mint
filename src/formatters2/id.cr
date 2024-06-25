module Mint
  class Formatter2
    def format(node : Ast::Id) : Nodes
      [node.value] of Node
    end
  end
end
