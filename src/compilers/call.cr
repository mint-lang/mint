module Mint
  class Compiler
    def compile(node : Ast::Call) : Compiled
      compile node do
        expression =
          compile node.expression

        arguments =
          node
            .arguments
            .sort_by { |item| resolve_order.index(item) || -1 }
            .map { |item| compile item }

        receiver =
          case
          when node.expression.is_a?(Ast::InlineFunction)
            ["("] + expression + [")"]
          else
            expression
          end

        js.call(receiver, arguments, node.await)
      end
    end
  end
end
