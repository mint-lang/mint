module Mint
  class Formatter
    def format(node : Ast::Directives::Svg)
      "@svg(#{node.path})"
    end
  end
end
