module Mint
  class Formatter
    def format(node : Ast::Directives::Size) : Nodes
      ["@size("] + format(node.ref) + [")"]
    end
  end
end
