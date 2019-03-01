module Mint
  class Compiler
    def _compile(node : Ast::InlineFunction) : String
      body =
        compile node.body

      arguments =
        compile node.arguments

      js.arrow_function(arguments, js.return(body))
    end
  end
end
