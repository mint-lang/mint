module Mint
  class Formatter
    def format(node : Ast::Then) : String
      body =
        list [node.expression] + node.head_comments + node.tail_comments

      "then {\n#{body.indent}\n}"
    end
  end
end
