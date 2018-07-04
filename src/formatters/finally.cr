module Mint
  class Formatter
    def format(node : Ast::Finally) : String
      body =
        list [node.expression] + node.head_comments + node.tail_comments

      "finally {\n#{body.indent}\n}"
    end
  end
end
