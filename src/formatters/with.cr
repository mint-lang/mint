module Mint
  class Formatter
    def format(node : Ast::With) : Nodes
      ["with "] + format(node.items, ", ") + [" "] + format(node.body)
    end

    def format(node : Ast::WithItem) : Nodes
      item =
        format(node.name) + [" : "] + format(node.type)

      # A member of a component has its own keyword.
      if node.parent.is_a?(Ast::Component)
        ["with "] + item
      else
        item
      end
    end
  end
end
