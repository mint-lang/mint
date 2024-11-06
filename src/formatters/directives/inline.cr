module Mint
  class Formatter
    def format(node : Ast::Directives::Inline) : Nodes
      format("@inline(#{node.path})")
    end
  end
end
