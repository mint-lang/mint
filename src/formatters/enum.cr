module Mint
  class Formatter
    def format(node : Ast::Enum)
      name =
        format node.name

      body =
        format node.options, ",\n"

      "enum #{name} {\n#{body.indent}\n}"
    end
  end
end
