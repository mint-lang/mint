module Mint
  class Formatter
    def format(node : Ast::Directives::Highlight)
      "@highlight #{format(node.content)}"
    end
  end
end
