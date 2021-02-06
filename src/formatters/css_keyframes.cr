module Mint
  class Formatter
    def format(node : Ast::CssKeyframes) : String
      body =
        list node.selectors

      "@keyframes #{node.name} {\n#{indent(body)}\n}"
    end
  end
end
