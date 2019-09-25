module Mint
  class Formatter
    def format(node : Ast::CssMedia) : String
      body =
        list node.body

      "@media #{node.content.strip} {\n#{indent(body)}\n}"
    end
  end
end
