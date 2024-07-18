module Mint
  class Compiler2
    def compile(node : Ast::InlineFunction) : Compiled
      compile node do
        body =
          case item = node.body
          when Ast::Block
            compile item, for_function: true
          else
            compile item
          end

        arguments =
          compile node.arguments

        if async?(node.body.expressions)
          js.async_arrow_function(arguments) { body }
        else
          js.arrow_function(arguments) { body }
        end
      end
    end
  end
end
