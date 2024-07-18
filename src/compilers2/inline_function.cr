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

        js.arrow_function(arguments) { body }
      end
    end
  end
end
