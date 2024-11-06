module Mint
  class Formatter
    def format(node : Ast::Variable) : Nodes
      format(node.value)
    end
  end
end
