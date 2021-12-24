module Mint
  class Formatter
    def format(node : Ast::Directives::Format)
      content =
        format node.content

      "@format {\n#{indent(content)}\n}"
    end
  end
end
