module Mint
  class Compiler
    def _compile(node : Ast::Call) : String
      expression =
        compile node.expression

      arguments =
        compile node.arguments, ", "

      if node.partially_applied
        "((..._) => #{expression}(#{arguments}, ..._))"
      else
        "#{expression}(#{arguments})"
      end
    end
  end
end
