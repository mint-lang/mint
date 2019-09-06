module Mint
  class Formatter
    def format(node : Ast::ArrayLiteral) : String
      items =
        format node.items, ",\n"

      if node.items.empty?
        "[]"
      elsif node.items.size == 1 && !replace_skipped(items).includes?("\n")
        "[#{items}]"
      else
        "[\n#{indent(items)}\n]"
      end
    end
  end
end
