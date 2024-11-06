module Mint
  class Formatter
    def format(node : Ast::FieldAccess) : Nodes
      [".#{node.name.value}("] + format(node.type) + [")"]
    end
  end
end
