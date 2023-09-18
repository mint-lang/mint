module Mint
  class Formatter
    def format(node : Ast::CssFontFace) : String
      body =
        list node.definitions

      "@font-face {\n#{indent(body)}\n}"
    end
  end
end
