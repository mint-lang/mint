module Mint
  class Compiler
    def _compile(node : Ast::InlineFunction) : String
      body =
        case item = node.body
        when Ast::Block
          compile item, for_function: true
        else
          compile item
        end

      arguments =
        compile node.arguments

      if async?(node.body)
        js.async_arrow_function(arguments, body)
      else
        js.arrow_function(arguments, body)
      end
    end
  end
end
