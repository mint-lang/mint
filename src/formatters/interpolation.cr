module Mint
  class Formatter
    def format(node : Ast::Interpolation) : String
      body =
        format node.expression

      "\#{#{body}}"
    end
  end
end
