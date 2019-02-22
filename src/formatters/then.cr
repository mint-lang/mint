module Mint
  class Formatter
    def format(node : Ast::Then) : String
      body =
        list [node.expression] + node.head_comments + node.tail_comments

      "then {\n#{indent(body)}\n}"
    end
  end
end
