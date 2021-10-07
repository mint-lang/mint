module Mint
  class Formatter
    def format(node : Ast::Then) : String
      body =
        format node.expression

      "then {\n#{indent(body)}\n}"
    end
  end
end
