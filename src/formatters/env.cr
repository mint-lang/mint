module Mint
  class Formatter
    def format(node : Ast::Env) : Nodes
      format("@#{node.name}")
    end
  end
end
