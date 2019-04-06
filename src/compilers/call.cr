module Mint
  class Compiler
    def _compile(node : Ast::Call) : String
      expression =
        compile node.expression

      arguments =
        compile node.arguments, ", "

      if node.partially_applied
        # If there are no arguments just return the function
        if node.arguments.empty?
          expression
        else
          "((..._) => #{expression}(#{arguments}, ..._))"
        end
      else
        "#{expression}(#{arguments})"
      end
    end
  end
end
