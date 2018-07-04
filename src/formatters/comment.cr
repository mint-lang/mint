module Mint
  class Formatter
    def format(node : Ast::Comment) : String
      value =
        node
          .value
          .remove_leading_whitespace
          .rstrip

      if value.includes?("\n")
        "/*\n#{value}\n*/"
      else
        "/* #{value} */"
      end
    end
  end
end
