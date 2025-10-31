module Mint
  class Formatter
    def format(node : Ast::Provide) : Nodes
      ["provide "] + format(node.name) + [" "] + format(node.expression)
    end
  end
end
