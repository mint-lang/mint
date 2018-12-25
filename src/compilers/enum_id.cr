module Mint
  class Compiler
    def _compile(node : Ast::EnumId) : String
      prefix =
        underscorize node.name

      name =
        underscorize node.option

      expressions =
        compile node.expressions, ","

      "new $$#{prefix}_#{name}(#{expressions})"
    end
  end
end
