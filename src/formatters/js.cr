module Mint
  class Formatter
    def format(node : Ast::Js) : String
      skip do
        body =
          node.value.map do |item|
            case item
            when Ast::Node
              "\#{#{format(item)}}"
            else
              format(item).gsub(/`/, "\\`")
            end
          end.join("")

        "`#{body}`"
      end
    end
  end
end
