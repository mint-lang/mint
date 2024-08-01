module Mint
  class Formatter
    def format(node : Ast::CssDefinition) : Nodes
      head =
        "#{node.name}: "

      items =
        node.value.map do |item|
          case item
          when String
            item
          else
            format(item)
          end
        end

      [head] + nested_string(items: items, indentation: head.size) + [";"]
    end
  end
end
