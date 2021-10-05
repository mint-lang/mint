module Mint
  class Compiler
    def _compile(node : Ast::Block) : String
      if node.statements.size == 1
        compile node.statements.first
      else
        compiled_statements =
          compile(
            node
              .statements
              .sort_by! { |item| resolve_order.index(item) || -1 })

        last =
          compiled_statements.pop

        js.iif do
          js.statements(compiled_statements + [js.return(last)])
        end
      end
    end
  end
end
