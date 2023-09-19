module Mint
  class Formatter
    def self.format(file) : String
      formatter = new(Parser.parse(file))
      formatter.format
    end

    def format(ast : Ast) : String
      body = (
        ast.type_definitions +
        ast.providers +
        ast.components +
        ast.modules +
        ast.routes +
        ast.stores +
        ast.suites +
        ast.comments +
        ast.locales
      )
        .sort_by!(&.from)
        .map { |node| format node }

      result =
        body
          .join("\n\n")
          .remove_trailing_whitespace + "\n"

      replace_skipped(result)
    end
  end
end
