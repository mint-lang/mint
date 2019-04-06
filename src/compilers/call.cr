module Mint
  class Compiler
    def _compile(node : Ast::Call) : String
      expression =
        compile node.expression

      arguments =
        compile node.arguments, ", "

      "#{expression}(#{arguments})"
    end
  end
end
