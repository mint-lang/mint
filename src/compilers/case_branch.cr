module Mint
  class Compiler
    def _compile(node : Ast::CaseBranch,
                 index : Int32,
                 variable : String,
                 block : Proc(String, String)? = nil) : Tuple(String?, String)
      expression =
        case item = node.expression
        when Array(Ast::CssDefinition)
          compiled =
            if block
              _compile item, block
            else
              "{}"
            end
        when Ast::Node
          js.return(compile(item))
        else
          ""
        end

      if match = node.match
        case match
        when Ast::ArrayDestructuring, Ast::TupleDestructuring, Ast::EnumDestructuring
          compiled =
            _compile(match, variable)

          compiled[1] << expression
          {
            compiled[0],
            js.statements(compiled[1]),
          }
        else
          compiled =
            compile match

          {
            "_compare(#{variable}, #{compiled})",
            expression,
          }
        end
      else
        {nil, expression}
      end
    end
  end
end
