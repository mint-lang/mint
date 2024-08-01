module Mint
  class Formatter
    def format(node : Ast::Directives::Asset) : Nodes
      format("@asset(#{node.path})")
    end
  end
end
