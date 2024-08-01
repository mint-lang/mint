module Mint
  class Formatter
    def format(node : Ast::BoolLiteral) : Nodes
      format(node.value.to_s)
    end
  end
end
