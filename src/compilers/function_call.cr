module Mint
  class Compiler
    def _compile(node : Ast::FunctionCall) : String
      variable =
        compile node.function

      arguments =
        compile node.arguments, ", "

      "#{variable}(#{arguments})"
    end
  end
end
