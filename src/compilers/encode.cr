module Mint
  class Compiler
    def _compile(node : Ast::Encode) : String
      expression =
        compile node.expression

      code =
        @serializer.encoder cache[node.expression]

      "#{code}(#{expression})"
    end
  end
end
