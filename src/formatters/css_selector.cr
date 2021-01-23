module Mint
  class Formatter
    def format(node : Ast::CssSelector) : String
      selectors =
        node
          .selectors
          .join(",\n") { |item| item.starts_with?(' ') ? item.lstrip : "&#{item}" }

      body =
        list node.body

      "#{selectors} {\n#{indent(body)}\n}"
    end
  end
end
