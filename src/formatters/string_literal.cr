module Mint
  class Formatter
    def format(node : Ast::StringLiteral) : Nodes
      if node.broken?
        broken_string(
          items: node.value.map do |item|
            case item
            in Ast::Node
              format(item)
            in String
              item
            end
          end)
      else
        [%(")] + node.value.reduce([] of Node) do |memo, item|
          case item
          in Ast::Node
            memo + format(item)
          in String
            memo + [item]
          end
        end + [%(")]
      end
    end
  end
end
