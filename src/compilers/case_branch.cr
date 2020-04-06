module Mint
  class Compiler
    def _compile(node : Ast::CaseBranch,
                 index : Int32,
                 variable : String,
                 block : Proc(String, String) | Nil = nil) : Tuple(String | Nil, String)
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
        when Ast::ArrayDestructuring
          statements =
            _compile(match, variable)

          statements << expression

          if match.spread?
            {
              "Array.isArray(#{variable}) && #{variable}.length >= #{match.items.size - 1}",
              js.statements(statements),
            }
          else
            {
              "Array.isArray(#{variable}) && #{variable}.length === #{match.items.size}",
              js.statements(statements),
            }
          end
        when Ast::TupleDestructuring
          variables =
            match
              .parameters
              .join(',') { |param| js.variable_of(param) }

          {
            "Array.isArray(#{variable})",
            js.statements([
              "const [#{variables}] = #{variable}",
              expression,
            ]),
          }
        when Ast::EnumDestructuring
          variables =
            match.parameters.map_with_index do |param, index1|
              "const #{js.variable_of(param)} = #{variable}._#{index1}"
            end

          name =
            js.class_of(lookups[match])

          {
            "#{variable} instanceof #{name}",
            js.statements(variables + [expression]),
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
