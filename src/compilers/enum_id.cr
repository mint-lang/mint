module Mint
  class Compiler
    def _compile(node : Ast::EnumId) : String
      name =
        js.class_of(lookups[node])

      expressions =
        compile node.expressions, ","

      "new #{name}(#{expressions})"
    end
  end
end
