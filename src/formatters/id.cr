module Mint
  class Formatter
    def format(node : Ast::Id) : Nodes
      format(node.value)
    end
  end
end
