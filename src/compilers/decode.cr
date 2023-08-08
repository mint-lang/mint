module Mint
  class Compiler
    def _compile(node : Ast::Decode) : String
      type =
        cache[node]

      object =
        case type.name
        when "Result"
          type.parameters.last
        when "Function"
          type.parameters.last.parameters.last
        else
          raise "SHOULD NOT HAPPEN"
        end

      code =
        @serializer.decoder object

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
