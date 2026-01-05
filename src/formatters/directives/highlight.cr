module Mint
  class Formatter
    def format(node : Ast::Directives::Highlight) : Nodes
      ["@highlight "] + format(node.content, BlockFormat::Outdented)
    end
  end
end
