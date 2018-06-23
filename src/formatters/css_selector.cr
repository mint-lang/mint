module Mint
  class Formatter
    def format(node : Ast::CssSelector) : String
      selectors =
        node
          .selectors
          .map { |item| "&#{item}" }
          .join(",\n")

      items =
        node.definitions + node.comments

      body =
        list items

      "#{selectors} {\n#{body.indent}\n}"
    end
  end
end
