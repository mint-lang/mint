module Mint
  class Formatter
    def format(node : Ast::Directives::Documentation) : Nodes
      format("@documentation(#{node.entity.value})")
    end
  end
end
