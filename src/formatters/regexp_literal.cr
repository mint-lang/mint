module Mint
  class Formatter
    def format(node : Ast::RegexpLiteral) : String
      node.static_value
    end
  end
end
