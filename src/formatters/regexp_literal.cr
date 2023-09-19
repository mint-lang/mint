module Mint
  class Formatter
    def format(node : Ast::RegexpLiteral) : String
      static_value(node).to_s
    end
  end
end
