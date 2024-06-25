module Mint
  class Formatter2
    def format(node : Ast::Variable) : Nodes
      [node.value] of Node
    end
  end
end
