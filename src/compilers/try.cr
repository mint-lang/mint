module Mint
  class Compiler
    def _compile(node : Ast::Try) : String
      catch_all =
        node.catch_all.try do |catch|
          js.let("_catch_all", js.arrow_function([] of String, "return #{compile(catch.expression)}")) + "\n\n"
        end

      body = node.statements.map_with_index do |statement, index|
        prefix =
          case
          when (index + 1) == node.statements.size
            "return "
          when statement.name
            "let #{js.variable_of(statement)} = "
          end

        expression =
          compile statement

        type = types[statement]?

        catches =
          case type
          when TypeChecker::Type
            if type.name == "Result" && type.parameters[0]
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
                js.let("_error", "_#{index}.value"),
                catches,
              ])
            end,
            "#{prefix}_#{index}.value",
          ])
        else
          "#{prefix}#{expression}"
        end
      end

      js.iif("#{catch_all}#{js.statements(body)}")
    end
  end
end
