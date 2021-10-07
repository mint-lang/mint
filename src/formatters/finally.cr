module Mint
  class Formatter
    def format(node : Ast::Finally) : String
      body =
        format node.expression

      "finally {\n#{indent(body)}\n}"
    end
  end
end
