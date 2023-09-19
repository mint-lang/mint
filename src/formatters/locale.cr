module Mint
  class Formatter
    def format(node : Ast::Locale) : String
      body =
        format node.fields

      "locale #{node.language} {\n#{indent(body.join(",\n"))}\n}"
    end
  end
end
