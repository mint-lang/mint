module Mint
  class Formatter
    def format(node : Ast::Catch) : String
      body =
        list [node.expression] + node.head_comments + node.tail_comments

      variable =
        format node.variable

      type =
        format node.type

      "catch #{type} => #{variable} {\n#{indent(body)}\n}"
    end
  end
end
