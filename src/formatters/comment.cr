module Mint
  class Formatter
    def format(node : Ast::Comment) : String
      value =
        node
          .content
          .remove_leading_whitespace
          .rstrip

      if node.type.block?
        if replace_skipped(value).includes?('\n')
          "/*\n#{value}\n*/"
        else
          "/* #{value} */"
        end
      else
        if value.size > 0 && value[0] != ' '
          "// #{value}"
        else
          "//#{value}"
        end
      end
    end
  end
end
