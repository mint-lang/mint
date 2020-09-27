module Mint
  class Formatter
    def format(node : Ast::Js) : String
      body =
        node.value.join do |item|
          case item
          when Ast::Node
            format(item)
          else
            format(item).gsub('`', "\\`")
          end
        end

      type =
        node.type.try do |item|
          " as #{format(item)}"
        end

      body =
        if body.includes?('\n')
          skip { body }
        else
          body
        end

      "`#{body}`#{type}"
    end
  end
end
