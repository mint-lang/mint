module Mint
  class Compiler
    def _compile(node : Ast::EnumId) : Codegen::Node
      name =
        js.class_of(lookups[node])

      expressions =
        compile node.expressions, ","

      Codegen.join ["new ", name, "(", expressions, ")"]
    end
  end
end
