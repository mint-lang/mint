module Mint
  class Compiler
    def _compile(node : Ast::Decode) : String
      expression =
        compile node.expression

      code =
        @serializer.decoder types[node]

      "#{code}(#{expression})"
    end
  end
end
