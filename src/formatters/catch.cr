module Mint
  class Formatter
    def format(node : Ast::Catch) : String
      body =
        format node.expression

      variable =
        format node.variable

      type =
        format node.type

      "catch #{type} => #{variable} #{body}"
    end
  end
end
