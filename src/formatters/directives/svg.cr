module Mint
  class Formatter
    def format(node : Ast::Directives::Svg) : Nodes
      format("@svg(#{node.path})")
    end
  end
end
