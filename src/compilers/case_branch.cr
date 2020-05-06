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
        when Ast::DestructuringType
          tmp = case match
          when Ast::ArrayDestructuring
            _compile match, variable
          when Ast::TupleDestructuring
            _compile match, variable
          when Ast::EnumDestructuring
            _compile match, variable
          else
          end.not_nil!

          {
            tmp[1],
            js.statements(tmp[0].concat([
              expression,
            ])),
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
