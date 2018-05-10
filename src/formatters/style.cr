module Mint
  class Formatter
    def format(node : Ast::Style) : String
      items =
        node.definitions + node.selectors + node.medias

      name =
        format node.name

      body =
        list items

      "style #{name} {\n#{body.indent}\n}"
    end
  end
end
