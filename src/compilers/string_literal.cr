module Mint
  class Compiler
    def _compile(node : Ast::StringLiteral) : String
      value =
        node.value.gsub('`', "\\`")

      "`#{value}`"
    end
  end
end
