module Mint
  class Formatter
    def format(node : Ast::Style) : String
      name =
        format node.name

      body =
        list node.body

      "style #{name} {\n#{indent(body)}\n}"
    end
  end
end
