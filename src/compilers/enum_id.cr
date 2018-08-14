module Mint
  class Compiler
    def compile(node : Ast::EnumId) : String
      prefix =
        underscorize node.name

      name =
        underscorize node.option

      "$#{prefix}_#{name}"
    end
  end
end
