module Mint
  class Formatter
    def format(node : Ast::Comment) : String
      formatted =
        if node.type.block?
          value =
            node
              .content
              .remove_leading_whitespace
              .rstrip

          if replace_skipped(value).includes?('\n')
            "/*\n#{value}\n*/"
          else
            "/* #{value} */"
          end
        else
          value =
            node.content

          if value.size > 0 && value[0] != ' '
            "// #{value}"
          else
            "//#{value}"
          end
        end

      [
        formatted,
        format(node.next_comment),
      ].compact.join("\n")
    end
  end
end
