module Mint
  class Formatter2
    def format(node : Ast::BoolLiteral) : Nodes
      [node.value.to_s] of Node
    end
  end
end
