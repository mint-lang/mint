module Mint
  class Formatter
    def format(node : Ast::HereDocument) : Nodes
      value =
        node.value.reduce([] of Node) do |memo, item|
          case item
          when Ast::Node
            memo + format(item)
          when String
            memo + [item] of Node
          else
            memo
          end
        end

      flags =
        if node.highlight
          format("(highlight)")
        else
          [] of Node
        end

      ["<<#{node.modifier}#{node.token}"] + flags + value + [node.token]
    end
  end
end
