module Mint
  class Formatter
    def format(node : Ast::CssMedia) : String
      items =
        node.definitions + node.comments

      body =
        list items

      "@media #{node.content.strip} {\n#{body.indent}\n}"
    end
  end
end
