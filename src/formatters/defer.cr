module Mint
  class Formatter
    def format(node : Ast::Defer) : Nodes
      ["defer "] + format(node.body)
    end
  end
end
