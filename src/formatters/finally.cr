module Mint
  class Formatter
    def format(node : Ast::Finally) : String
      body =
        list [node.expression] + node.head_comments + node.tail_comments

      "finally {\n#{indent(body)}\n}"
    end
  end
end
