module Mint
  class Compiler
    def _compile(node : Ast::Parallel) : String
      body = node.statements.map do |statement|
        name =
          if statement.name
            js.variable_of(statement)
          end

        prefix =
          if name
            "#{name} = "
          end

        expression =
          compile statement.expression

        # Get the time of the statment
        type = types[statement]?

        catches =
          case type
          when TypeChecker::Type
            if (type.name == "Promise" || type.name == "Result") && type.parameters[0]
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
            if catches && catches.empty?
              js.asynciif do
                js.statements([
                  js.let("_", expression),
                  js.if("_ instanceof Err") do
                    "throw _._0"
                  end,
                  "#{prefix}_._0",
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
                  "#{prefix}_._0",
                ])
              end
            end
          when "Promise"
            if catches && !catches.empty?
              js.asynciif do
                js.try("#{prefix}await #{expression}",
                  [js.catch("_error", js.statements(catches))],
                  "")
              end
            end
          end
        end || js.asynciif do
          "#{prefix}await #{expression}"
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
          js.let(js.variable_of(statement), "null") if statement.name
        end.compact

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
