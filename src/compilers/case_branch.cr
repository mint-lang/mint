module Mint
  class Compiler
    def compile(
      node : Ast::CaseBranch,
      block : Proc(String, String)? = nil,
    ) : Compiled
      compile node do
        expression =
          case item = node.expression
          when Array(Ast::CssDefinition)
            compile item, block if block
          when Ast::Node
            compile(item)
          end || [] of Item

        if patterns = node.patterns
          variables =
            [] of Compiled

          matcher =
            if patterns.size == 1
              destructuring(patterns.first, variables)
            else
              patterns =
                patterns.map { |pattern| destructuring(pattern, variables) }

              js.call(Builtin::PatternMany, [js.array(patterns)])
            end

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
