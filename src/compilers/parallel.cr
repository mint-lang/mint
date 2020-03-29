module Mint
  class Compiler
    def _compile(node : Ast::Parallel) : String
      body = node.statements.map do |statement|
        prefix = ->(value : String) {
          case target = statement.target
          when Ast::Variable
            js.assign(js.variable_of(target), value)
          when Ast::TupleDestructuring
            variables =
              target
                .parameters
                .join(',') { |param| js.variable_of(param) }

            "[#{variables}] = #{value}"
          else
            value
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
            end
          end || [] of String

        case type
        when TypeChecker::Type
          case type.name
          when "Result"
            if catches.empty?
              js.asynciif do
                js.statements([
                  js.let("_", expression),
                  js.if("_ instanceof Err") do
                    "throw _._0"
                  end,
                  prefix.call("_._0"),
                ])
              end
            else
              js.asynciif do
                js.statements([
                  js.let("_", expression),
                  js.if("_ instanceof Err") do
                    js.statements([
                      js.let("_error", "_._0"),
                    ] + catches)
                  end,
                  prefix.call("_._0"),
                ])
              end
            end
          when "Promise"
            if catches && !catches.empty?
              js.asynciif do
                js.try(prefix.call("await #{expression}"),
                  [js.catch("_error", js.statements(catches))],
                  "")
              end
            end
          end
        end || js.asynciif do
          prefix.call("await #{expression}")
        end
      end

      catch_all =
        node.catch_all.try do |catch|
          "return #{compile catch.expression}"
        end ||
          js.statements([
            "console.warn(`Unhandled error in parallel expression:`)",
            "console.warn(_error)",
          ])

      finally =
        if node.finally
          compile node.finally.not_nil!
        end

      then_block =
        if node.then_branch
          js.assign("_", compile(node.then_branch.not_nil!.expression))
        end

      names =
        node.statements.map do |statement|
          case target = statement.target
          when Ast::Variable
            js.let(js.variable_of(target), "null")
          when Ast::TupleDestructuring
            target.parameters.map do |variable|
              js.let(js.variable_of(variable), "null")
            end
          end
        end.flatten.compact

      js.asynciif do
        js.statements([
          js.let("_", "null"),
          js.try(
            js.statements(names + [
              js.call("await Promise.all", [js.array(body)]),
              then_block,
            ].compact),
            [
              js.catch("_error") do
                js.if("!(_error instanceof DoError)", catch_all)
              end,
            ],
            finally || ""),
          js.return("_"),
        ])
      end
    end
  end
end
