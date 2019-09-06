module Mint
  class Formatter
    def format(node : Ast::Js) : String
      body =
        node.value.map do |item|
          case item
          when Ast::Node
            "\#{#{format(item)}}"
          else
            format(item).gsub(/`/, "\\`")
          end
        end.join("")

      result =
        "`#{body}`"

      if result.includes?("\n")
        skip { result }
      else
        result
      end
    end
  end
end
