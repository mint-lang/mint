module Mint
  class Compiler
    def _compile(node : Ast::CaseBranch, block : Proc(String, String)? = nil) : String
      expression =
        case item = node.expression
        when Array(Ast::CssDefinition)
          if block
            _compile item, block
          else
            "{}"
          end
        when Ast::Node
          compile(item)
        else
          ""
        end

      if pattern = node.pattern
        variables =
          [] of String

        matcher =
          destructuring(pattern, variables)

        js.array([matcher, js.arrow_function(variables, js.return(expression))])
      else
        js.array(["null", js.arrow_function([] of String, js.return(expression))])
      end
    end
  end
end
