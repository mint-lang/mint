module Mint
  class Formatter
    def format(node : Ast::CatchAll) : String
      body =
        format node.expression

      "catch #{body}"
    end
  end
end
