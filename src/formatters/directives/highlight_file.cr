module Mint
  class Formatter
    def format(node : Ast::Directives::HighlightFile)
      "@highlight-file(#{node.path})"
    end
  end
end
