module Mint
  class Compiler
    def _compile(node : Ast::Decode) : Codegen::Node
      expression =
        compile node.expression

      code =
        @serializer.decoder types[node]

      Codegen.join [code, "(", expression, ")"]
    end
  end
end
