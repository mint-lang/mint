module Mint
  class Formatter
    def format(node : Ast::TupleLiteral) : String
      mutliline =
        if node.items.size > 0
          Ast.new_line?(node.items.first, node.items.last)
        else
          false
        end

      items =
        format node.items, mutliline ? ",\n" : ", "

      if mutliline || replace_skipped(items).includes?('\n')
        "{\n#{indent(items)}\n}"
      else
        "{#{items}}"
      end
    end
  end
end
