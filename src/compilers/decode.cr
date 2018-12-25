module Mint
  class Compiler
    def _compile(node : Ast::Decode) : String
      expression =
        compile node.expression

      code =
        @decoder.generate types[node]

      "#{code}(#{expression})"
    end
  end
end
