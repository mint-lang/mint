module Mint
  class Compiler
    def _compile(node : Ast::Encode) : Codegen::Node
      expression =
        compile node.expression

      code =
        @serializer.encoder cache[node.expression]

      Codegen.join [code || "", "(", expression, ")"]
    end
  end
end
