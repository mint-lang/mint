module Mint
  class Formatter
    def format(node : Ast::LocaleKey) : Nodes
      format(":#{node.value}")
    end
  end
end
