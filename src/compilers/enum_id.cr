module Mint
  class Compiler
    def compile(node : Ast::EnumId)
      prefix =
        underscorize node.name

      name =
        underscorize node.option

      "$#{prefix}_#{name}"
    end
  end
end
