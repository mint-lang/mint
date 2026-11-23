module Mint
  class Compiler
    def compile(node : Ast::Block, for_function = false) : Compiled
      compile node do
        expressions = [] of Compiled

        if fallback = node.fallback
          variable = Variable.new

          expressions.unshift(js.const(variable,
            js.arrow_function { js.return(compile(fallback)) }))

          @fallbacks[fallback] = variable
        end
        statements =
          node.expressions.select(Ast::Statement)

        # A `with` or `provide` at the end of a function is compiled into
        # the function itself.
        if for_function && !node.fallback &&
           (last = statements.last?) &&
           !last.target && !last.return_value &&
           (item = last.expression).is_a?(Ast::With | Ast::Provide)
          expressions.concat(compile(statements[0...-1]))
          expressions << compile(item, for_function: true)

          next js.statements(expressions)
        end

        expressions.concat(compile(statements))

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
