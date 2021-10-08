module Mint
  class Formatter
    def format(node : Ast::Then) : String
      body =
        format node.expression

      "then #{body}"
    end
  end
end
