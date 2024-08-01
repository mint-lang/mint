module Mint
  class Formatter
    def format(node : Ast::TypeDestructuring) : Nodes
      items =
        format_arguments node.items, empty_parenthesis: false

      name =
        if node.name
          format(node.name) + ["."]
        else
          [] of Node
        end

      name + format(node.variant) + items
    end
  end
end
