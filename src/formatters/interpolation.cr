module Mint
  class Formatter
    def format(node : Ast::Interpolation) : Nodes
      ["\#{"] + format(node.expression) + ["}"]
    end
  end
end
