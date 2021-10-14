module Mint
  class Compiler
    def _compile(node : Ast::Call) : String
      expression =
        compile node.expression

      arguments =
        compile node.arguments, ", "

      case
      when node.partially_applied?
        if node.arguments.empty?
          expression
        else
          "((..._) => #{expression}(#{arguments}, ..._))"
        end
      when node.expression.is_a?(Ast::InlineFunction)
        "(#{expression})(#{arguments})"
      else
        "#{expression}(#{arguments})"
      end
    end
  end
end
