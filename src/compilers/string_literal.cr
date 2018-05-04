module Mint
  class Compiler
    def compile(node : Ast::StringLiteral) : String
      value =
        node.value.gsub('`', "\\`")

      "`#{value}`"
    end
  end
end
