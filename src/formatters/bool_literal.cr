module Mint
  class Formatter
    def format(node : Ast::BoolLiteral) : String
      node.value.to_s
    end
  end
end
