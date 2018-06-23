module Mint
  class Formatter
    def format(node : Ast::Catch) : String
      body =
        format node.expression, node.head_comment, node.tail_comment

      variable =
        format node.variable

      type =
        format node.type

      "catch #{type} => #{variable} {\n#{body.indent}\n}"
    end
  end
end
