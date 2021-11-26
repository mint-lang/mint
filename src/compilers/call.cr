module Mint
  class Compiler
    def _compile(node : Ast::Call) : String
      expression =
        compile node.expression

      arguments =
        compile node.arguments, ", "

      case
      when node.expression.is_a?(Ast::InlineFunction)
        "(#{expression})(#{arguments})"
      else
        "#{expression}(#{arguments})"
      end
    end
  end
end
