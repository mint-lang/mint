module Mint
  class Compiler
    def _compile(node : Ast::Decode) : String
      code =
        @serializer.decoder types[node]

      if item = node.expression
        expression =
          compile item

        "#{code}(#{expression})"
      else
        "((_)=>#{code}(_))"
      end
    end
  end
end
