module Mint
  class Formatter
    def format(node : Ast::TypeVariable) : Nodes
      format(node.value)
    end
  end
end
