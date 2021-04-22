module Mint
  class Formatter
    def format(node : Ast::Directives::Inline)
      "@inline(#{node.path})"
    end
  end
end
