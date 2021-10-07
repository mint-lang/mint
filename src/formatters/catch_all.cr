module Mint
  class Formatter
    def format(node : Ast::CatchAll) : String
      body =
        format node.expression

      "catch {\n#{indent(body)}\n}"
    end
  end
end
