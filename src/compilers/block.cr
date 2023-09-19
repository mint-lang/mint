module Mint
  class Compiler
    def compile(node : Ast::Block, for_function = false) : String
      node.in?(checked) ? _compile(node, for_function) : ""
    end

    def _compile(node : Ast::Block, for_function = false) : String
      expressions =
        node
          .expressions
          .select(Ast::Statement)
          .sort_by! { |item| resolve_order.index(item) || -1 }
          .flat_map { |item| _compile2 item }

      last =
        expressions.pop

      if expressions.empty? && !async?(node)
        if for_function
          js.return(last)
        else
          last
        end
      elsif for_function
        js.statements(expressions + [js.return(last)])
      elsif async?(node)
        js.asynciif do
          js.statements(expressions + [js.return(last)])
        end
      else
        js.iif do
          js.statements(expressions + [js.return(last)])
        end
      end
    end
  end
end
