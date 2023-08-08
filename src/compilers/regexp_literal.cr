module Mint
  class Compiler
    def _compile(node : Ast::RegexpLiteral) : String
      static_value(node).to_s
    end
  end
end
