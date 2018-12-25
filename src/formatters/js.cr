module Mint
  class Formatter
    def format(node : Ast::Js) : String
      body =
        node.value.map do |item|
          case item
          when Ast::Node
            "\#{#{format(item)}}"
          else
            format item
          end
        end.join("")

      if body.includes?("\n") || body.includes?("\r")
        value =
          body
            .remove_leading_whitespace
            .gsub(/`/, "\\`")

        "`\n#{value}\n`"
      else
        value =
          body
            .strip
            .gsub(/`/, "\\`")

        "`#{value}`"
      end
    end
  end
end
