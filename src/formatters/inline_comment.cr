module Mint
  class Formatter
    def format(node : Ast::InlineComment) : String
      value =
        node
          .value
          .remove_leading_whitespace
          .rstrip

      "// #{value}"
    end
  end
end
