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
          variables = get_enum_destruct_vars match, variable

          res = {
            get_enum_destruct_condition(match, variable),
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

    def get_enum_destruct_condition(match, variable)
      pp match
      name =
        js.class_of(lookups[match]? || match)

      condition = "#{variable} instanceof #{name}"
      match.parameters.each_with_index do |param, index|
        case param
        when Ast::EnumDestructuring
          condition += " && (" + get_enum_destruct_condition(param, "#{variable}._#{index}") + ")"
        else
        end
      end
      condition
    end

    def get_enum_destruct_vars(match, variable)
      variables =
        match.parameters.map_with_index do |param, index1|
          vars = ["const #{js.variable_of(param)} = #{variable}._#{index1}"]
          case param
          when Ast::EnumDestructuring
            vars += get_enum_destruct_vars param, variable
          else
          end
          vars
        end
      variables.flatten
    end
  end
end
