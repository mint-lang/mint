module Mint
  class Formatter
    def format(node : Ast::Spread) : String
      "...#{format(node.variable)}"
    end
  end
end
