module Mint
  class Compiler
    def _compile(node : Ast::Argument) : String
      vars[node]? || (vars[node] = js.next_variable)
    end
  end
end
