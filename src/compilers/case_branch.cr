module Mint
  class Compiler
    def _compile(node : Ast::CaseBranch,
                 index : Int32,
                 variable : String,
                 block : Proc(String, String)? = nil) : Tuple(String?, String)
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

      if match = node.match
        variables = [] of String
        x = destructuring(match, variables)
        {x, js.arrow_function(variables, js.return(expression))}
      else
        {nil, js.arrow_function([] of String, js.return(expression))}
      end
    end
  end
end
