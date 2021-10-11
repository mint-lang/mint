module Mint
  class Compiler
    def compile(node : Ast::Block, for_function = false) : String
      if checked.includes?(node)
        _compile(node, for_function)
      else
        ""
      end
    end

    def _compile(node : Ast::Block, for_function = false) : String
      statements =
        node.statements.select(Ast::Statement)

      if statements.size == 1
        if for_function
          js.return(compile(statements.first))
        else
          compile(statements.first)
        end
      else
        compiled_statements =
          compile(statements.sort_by! { |item| resolve_order.index(item) || -1 })

        last =
          compiled_statements.pop

        if for_function
          js.statements(compiled_statements + [js.return(last)])
        else
          if node.async?
            js.asynciif do
              js.statements(compiled_statements + [js.return(last)])
            end
          else
            js.iif do
              js.statements(compiled_statements + [js.return(last)])
            end
          end
        end
      end
    end
  end
end
