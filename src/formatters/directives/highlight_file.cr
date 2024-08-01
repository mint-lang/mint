module Mint
  class Formatter
    def format(node : Ast::Directives::HighlightFile) : Nodes
      format("@highlight-file(#{node.path})")
    end
  end
end
