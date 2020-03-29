module Mint
  class Compiler
    def _compile(node : Ast::Try) : String
      catch_all =
        node.catch_all.try do |catch|
          js.let("_catch_all", js.arrow_function([] of String, "return #{compile(catch.expression)}")) + "\n\n"
        end

      body =
        node
          .statements
          .sort_by { |item| resolve_order.index(item) || -1 }
          .map_with_index do |statement, index|
            is_last =
              (index + 1) == node.statements.size

            prefix = ->(value : String) {
              if is_last
                "return #{value}"
              else
                case target = statement.target
                when Ast::Variable
                  js.let(js.variable_of(target), value)
                when Ast::TupleDestructuring
                  variables =
                    target
                      .parameters
                      .join(',') { |param| js.variable_of(param) }

                  "const [#{variables}] = #{value}"
                else
                  value
                end
              end
            }

            expression =
              compile statement

            type = types[statement]?

            catches =
              case type
              when TypeChecker::Type
                if type.name == "Result" && type.parameters[0] && !is_last
                  catched =
                    node.catches.map do |catch|
                      if catch.type == type.parameters[0].name
                        catch_body =
                          compile catch.expression

                        variable =
                          js.variable_of(catch)

                        js.statements([
                          js.let(variable, "_error"),
                          "return #{catch_body}",
                        ])
                      end
                    end

                  if catched.empty?
                    "return _catch_all()"
                  else
                    js.statements(catched.compact)
                  end
                end
              end

            if catches && !catches.empty?
              js.statements([
                js.let("_#{index}", expression),
                js.if("_#{index} instanceof Err") do
                  js.statements([
                    js.let("_error", "_#{index}._0"),
                    catches,
                  ])
                end,
                prefix.call("_#{index}._0"),
              ])
            else
              prefix.call(expression)
            end
          end

      js.iif("#{catch_all}#{js.statements(body)}")
    end
  end
end
