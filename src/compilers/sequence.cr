module Mint
  class Compiler
    def _compile(node : Ast::Sequence) : String
      body =
        node
          .statements
          .sort_by { |item| resolve_order.index(item) || -1 }
          .map_with_index do |statement, index|
            prefix = ->(value : String) {
              if (index + 1) == node.statements.size
                "_ = #{value}"
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
              compile statement.expression

            # Get the time of the statement
            type = types[statement]?

            catches =
              case type
              when TypeChecker::Type
                if type.name.in?("Promise", "Result") && type.parameters[0]
                  node
                    .catches
                    .select { |item| item.type == type.parameters[0].name }
                    .map { |item| compile(item).as(String) }
                else
                  [] of String
                end
              else
                [] of String
              end

            case type
            when TypeChecker::Type
              case type.name
              when "Result"
                if catches.empty?
                  js.statements([
                    js.let("_#{index}", expression),
                    js.if("_#{index} instanceof Err") do
                      "throw _#{index}._0"
                    end,
                    prefix.call("_#{index}._0"),
                  ])
                else
                  js.statements([
                    js.let("_#{index}", expression),
                    js.if("_#{index} instanceof Err") do
                      js.statements([
                        js.let("_error", "_#{index}._0"),
                      ] + catches)
                    end,
                    prefix.call("_#{index}._0"),
                  ])
                end
              when "Promise"
                unless catches.empty?
                  try = js.asynciif do
                    js.try(
                      body: "return await #{expression}",
                      catches: [
                        js.catch("_error") { js.statements(catches) },
                      ],
                      finally: "")
                  end

                  prefix.call("await #{try}")
                end
              end
            end || prefix.call("await #{expression}")
          end

      catch_all =
        node.catch_all.try do |catch|
          "_ = #{compile catch.expression}"
        end || js.statements([
          "console.warn(`Unhandled error in sequence expression:`)",
          "console.warn(_error)",
        ])

      finally =
        if node.finally
          compile node.finally.not_nil!
        end

      js.asynciif do
        js.statements([
          js.let("_", "null"),
          js.try(
            body: js.statements(body),
            catches: [
              js.catch("_error") do
                js.if("!(_error instanceof DoError)", catch_all)
              end,
            ],
            finally: finally.to_s),
          "return _",
        ])
      end
    end
  end
end
