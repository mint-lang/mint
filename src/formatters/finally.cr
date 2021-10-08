module Mint
  class Formatter
    def format(node : Ast::Finally) : String
      body =
        format node.expression

      "finally #{body}"
    end
  end
end
