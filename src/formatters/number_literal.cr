module Mint
  class Formatter
    def format(node : Ast::NumberLiteral) : String
      node.value
    end
  end
end
