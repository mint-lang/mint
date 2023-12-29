module Mint
  class Compiler
    def _compile(node : Ast::Call) : String
      expression =
        compile node.expression

      arguments =
        compile node.arguments.sort_by { |item| resolve_order.index(item) || -1 }, ", "

      case
      when node.expression.is_a?(Ast::InlineFunction)
        "(#{expression})(#{arguments})"
      else
        "#{expression}(#{arguments})"
      end
    end
  end
end
