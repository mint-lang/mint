module Mint
  class Formatter
    def format(node : Ast::Js) : Nodes
      body =
        node.value.reduce([] of Node) do |memo, item|
          case item
          when Ast::Interpolation
            memo + [item.source]
          else
            memo + format(item)
          end
        end

      type =
        format(node.type) do |item|
          [" as "] + format(item)
        end

      ["`"] + body + ["`"] + type
    end
  end
end
