module Mint
  class Formatter
    def format(node : Ast::Enum)
      name =
        format node.name

      items =
        node.options + node.comments

      body =
        list items

      "enum #{name} {\n#{body.indent}\n}"
    end
  end
end
