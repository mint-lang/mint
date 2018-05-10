module Mint
  class Formatter
    def format(node : Ast::Finally) : String
      body =
        format node.expression

      "finally {\n#{body.indent}\n}"
    end
  end
end
