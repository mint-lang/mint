module Mint
  class Compiler
    def _compile(node : Ast::Try) : String
      catch_all =
        node.catch_all.try do |catch|
          js.let("_catch_all", js.arrow_function([] of String, "return #{compile(catch.expression)}")) + "\n\n"
        end

      body = node.statements.map_with_index do |statement, index|
        is_last =
          (index + 1) == node.statements.size

        prefix = ->(value : String) {
          case
          when is_last
            "return #{value}"
          when variables = statement.variables
            if variables.size == 1
              js.let(js.variable_of(variables[0]), value)
            else
              statements =
                [js.let("$$$", value)]

              variables.each_with_index do |variable, variable_index|
                statements << js.let(js.variable_of(variable), "$$$[#{variable_index}]")
              end

              js.statements(statements)
            end
          else
            value
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

              if catched.any?
                js.statements(catched.compact)
              else
                "return _catch_all()"
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
