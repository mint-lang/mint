module Mint
  class Formatter
    def skip_string(string)
      if string.includes?('\n')
        skip { string }
      else
        string
      end
    end

    def format(node : Ast::StringLiteral) : String
      position = 0

      ('"' + node.value.reduce("") do |memo, item|
        case item
        when Ast::Node
          formatted =
            format(item)

          position +=
            replace_skipped(formatted).size

          memo + formatted
        when String
          size =
            item.size + position

          if size > 56 && node.broken
            item_array =
              item.split("")

            head =
              if position > 56
                [[""]]
              else
                diff =
                  56 - position

                [item_array.shift(diff)]
              end

            parts =
              (head + item_array.each_slice(56).to_a)
                .map(&.join(""))

            position =
              if parts.last.size == 56
                0
              else
                parts.last.size
              end

            parts.reduce(memo) do |part_memo, part|
              part_memo + skip_string(part) + "\" \\\n\""
            end
          else
            position += item.size
            memo + skip_string(item)
          end
        else
          memo
        end
      end.rchop("\" \\\n\"") + '"')
    end
  end
end
