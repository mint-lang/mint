module Mint
  class Compiler
    def compile(node : Ast::Encode) : String
      expression =
        compile node.expression

      "_encode(#{expression})"
    end
  end
end
