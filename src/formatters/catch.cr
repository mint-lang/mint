module Mint
  class Formatter
    def format(node : Ast::Catch) : String
      body =
        list [node.expression] + node.head_comments + node.tail_comments

      variable =
        format node.variable

      type =
        format node.type

      "catch #{type} => #{variable} {\n#{body.indent}\n}"
    end
  end
end
