module Mint
  class Formatter
    def format(node : Ast::Directives::Asset)
      "@asset(#{node.path})"
    end
  end
end
