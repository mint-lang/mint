module Mint
  class Compiler
    def _compile(node : Ast::Argument) : String
      js.variable_of(node)
    end
  end
end
