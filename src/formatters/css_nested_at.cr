module Mint
  class Formatter
    def format(node : Ast::CssNestedAt) : String
      body =
        list node.body

      "@#{node.name} #{node.content.strip} {\n#{indent(body)}\n}"
    end
  end
end
