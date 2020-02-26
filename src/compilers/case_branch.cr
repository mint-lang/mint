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
          if match.items.any?(Ast::Spread)
            statements = [
              "const _ = Array.from(#{variable})",
            ]

            match
              .items
              .take_while(&.is_a?(Ast::Variable))
              .each do |var|
                statements << "const #{js.variable_of(var)} = _.shift()"
              end

            match
              .items
              .reverse
              .take_while(&.is_a?(Ast::Variable))
              .each do |var|
                statements << "const #{js.variable_of(var)} = _.pop()"
              end

            statements << "const #{js.variable_of(match.items.select(Ast::Spread).first.variable)} = _"
            statements << expression

            {"Array.isArray(#{variable})", js.statements(statements)}
          else
            variables =
              match
                .items
                .map { |param| js.variable_of(param) }
                .join(",")

            {
              "Array.isArray(#{variable}) && #{variable}.length === #{match.items.size}",
              js.statements([
                "const [#{variables}] = #{variable}",
                expression,
              ]),
            }
          end
        when Ast::TupleDestructuring
          variables =
            match
              .parameters
              .map { |param| js.variable_of(param) }
              .join(",")

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
