module Mint
  class Compiler
    def _compile(node : Ast::Get) : String
      body =
        case item = node.body
        when Ast::Block
          compile item, for_function: true
        else
          compile item
        end

      name =
        js.variable_of(node)

      js.get(name, js.return(body))
    end
  end
end
