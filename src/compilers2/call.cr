module Mint
  class Compiler2
    def compile(node : Ast::Call) : Compiled
      expression =
        compile node.expression

      arguments =
        compile node.arguments.sort_by { |item| argument_order.index(item) || -1 }, ", "

      case
      when node.expression.is_a?(Ast::InlineFunction)
        ["("] + expression + [")("] + arguments + [")"]
      else
        expression + ["("] + arguments + [")"]
      end
    end
  end
end
