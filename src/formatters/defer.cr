module Mint
  class Formatter
    def format(node : Ast::Defer) : String
      body =
        format node.body

      "defer #{body}"
    end
  end
end
