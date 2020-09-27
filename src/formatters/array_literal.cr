module Mint
  class Formatter
    def format(node : Ast::ArrayLiteral) : String
      multiline =
        node.new_line?

      items =
        format node.items, multiline ? ",\n" : ", "

      type =
        node.type.try do |item|
          " of #{format(item)}"
        end

      head =
        if node.items.empty?
          "[]"
        elsif multiline || replace_skipped(items).includes?('\n')
          "[\n#{indent(items)}\n]"
        else
          "[#{items}]"
        end

      "#{head}#{type}"
    end
  end
end
