module Mint
  class Formatter
    def format(node : Ast::Builtin) : Nodes
      format("%#{node.value}%")
    end
  end
end
