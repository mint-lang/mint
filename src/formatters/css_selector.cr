module Mint
  class Formatter
    def format(node : Ast::CssSelector) : String
      selectors =
        node
          .selectors
          .map { |item| item.starts_with?(" ") ? item.lstrip : "&#{item}" }
          .join(",\n")

      body =
        list node.body

      "#{selectors} {\n#{indent(body)}\n}"
    end
  end
end
