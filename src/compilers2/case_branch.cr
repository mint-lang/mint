module Mint
  class Compiler2
    def compile(
      node : Ast::CaseBranch,
      block : Proc(String, String)? = nil
    ) : Compiled
      compile node do
        expression =
          case item = node.expression
          when Array(Ast::CssDefinition)
            if block
              compile item, block
            else
              ["{}"] of Item
            end
          when Ast::Node
            compile(item)
          else
            [] of Item
          end

        if pattern = node.pattern
          variables =
            [] of Compiled

          matcher =
            destructuring(pattern, variables)

          js.array([matcher, js.arrow_function(variables) { js.return(expression) }])
        else
          js.array([["null"], js.arrow_function([] of Compiled) { js.return(expression) }])
        end
      end
    end
  end
end
