module Mint
  class Formatter
    def format(node : Ast::TypeDestructuring)
      items =
        format node.items, ", "

      name =
        "#{format node.name}." if node.name

      if items.empty?
        "#{name}#{format node.variant}"
      else
        "#{name}#{format node.variant}(#{items})"
      end
    end
  end
end
