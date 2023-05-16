module Mint
  class Compiler
    def compile(node : Ast::Block, for_function = false) : String
      node.in?(checked) ? _compile(node, for_function) : ""
    end

    def _compile(node : Ast::Block, for_function = false) : String
      statements =
        node
          .statements
          .select(Ast::Statement)
          .sort_by! { |item| resolve_order.index(item) || -1 }
          .flat_map { |item| _compile2 item }

      last =
        statements.pop

      if statements.empty?
        if for_function
          js.return(last)
        else
          last
        end
      elsif for_function
        js.statements(statements + [js.return(last)])
      elsif node.async?
        js.asynciif do
          js.statements(statements + [js.return(last)])
        end
      else
        js.iif do
          js.statements(statements + [js.return(last)])
        end
      end
    end
  end
end
