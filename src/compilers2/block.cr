module Mint
  class Compiler2
    def compile(node : Ast::Block, for_function = false) : Compiled
      compile node do
        expressions =
          node
            .expressions
            .select(Ast::Statement)
            .sort_by! { |item| resolve_order.index(item) || -1 }
            .map { |item| compile item }

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
end
