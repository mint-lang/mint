module Mint
  class Compiler2
    def compile(node : Ast::Decode) : Compiled
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
        decoder object

      if item = node.expression
        js.call(code, [compile(item)])
      else
        code
      end
    end
  end
end
