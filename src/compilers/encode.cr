module Mint
  class Compiler
    def _compile(node : Ast::Encode) : String
      expression =
        compile node.expression

      "_encode(#{expression})"
    end
  end
end
