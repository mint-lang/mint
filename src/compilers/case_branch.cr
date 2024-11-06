module Mint
  class Compiler
    def compile(
      node : Ast::CaseBranch,
      block : Proc(String, String)? = nil
    ) : Compiled
      compile node do
        expression =
          case item = node.expression
          when Array(Ast::CssDefinition)
            compile item, block if block
          when Ast::Node
            compile(item)
          end || [] of Item

        if pattern = node.pattern
          variables =
            [] of Compiled

          matcher =
            destructuring(pattern, variables)

          js.array([
            matcher,
            js.arrow_function(variables) { js.return(expression) },
          ])
        else
          js.array([js.null, js.arrow_function { js.return(expression) }])
        end
      end
    end
  end
end
