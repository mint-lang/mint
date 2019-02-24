module Mint
  class Formatter
    def format(node : Ast::CatchAll) : String
      body =
        list [node.expression] + node.head_comments + node.tail_comments

      "catch {\n#{indent(body)}\n}"
    end
  end
end
