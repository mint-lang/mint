module Mint
  class Compiler
    def compile(node : Ast::Argument) : String
      vars[node]? || (vars[node] = js.next_variable)
    end
  end
end
