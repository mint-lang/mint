module Mint
  class Compiler
    def compile(node : Ast::Decode) : Compiled
      compile node do
        type =
          cache[node]

        object =
          case type.name
          when "Function"
            type.parameters.last.parameters.last
          when "Result"
            type.parameters.last
          else
            raise "Unkown decoder for type: #{type.name}!"
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
end
