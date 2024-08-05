module Mint
  class Compiler
    def compile(node : Ast::Block, for_function = false) : Compiled
      compile node do
        expressions =
          compile node.expressions.select(Ast::Statement)

        async =
          Js.async?(expressions)

        last =
          expressions.pop

        if expressions.empty? && !async
          if for_function
            js.return(last)
          else
            last
          end
        elsif for_function
          js.statements(expressions + [js.return(last)])
        else
          js.iif do
            js.statements(expressions + [js.return(last)])
          end
        end
      end
    end
  end
end
