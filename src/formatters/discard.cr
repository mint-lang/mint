module Mint
  class Formatter
    def format(node : Ast::Discard) : Nodes
      format("_")
    end
  end
end
