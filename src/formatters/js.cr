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

      if body.includes?("\n") || body.includes?("\r")
        value =
          body.remove_leading_whitespace

        "`\n#{value}\n`"
      else
        value =
          body.strip

        "`#{value}`"
      end
    end
  end
end
