module Mint
  class Formatter
    def format(node : Ast::With) : String
      body =
        format node.body

      "with #{node.name} {\n#{body.indent}\n}"
    end
  end
end
