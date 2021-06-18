module Mint
  class Compiler
    protected def prefix(_node : Ast::Parallel, statement : Ast::Statement, value : String)
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
    end

    def _compile(node : Ast::Parallel) : String
      _compile(node) { |statement| compile(statement) }
    end

    def _compile(node : Ast::Parallel, & : Ast::Statement, Int32, Bool -> String) : String
      statements = node.statements
      statements_size = statements.size

      body = statements.map_with_index do |statement, index|
        is_last =
          (index + 1) == statements_size

        expression =
          yield statement, index, is_last

        # Get the time of the statement
        type = types[statement]?

        catches =
          case type
          when TypeChecker::Type
            if type.name.in?("Promise", "Result") && (type_param = type.parameters.first?)
              node
                .catches
                .select(&.type.==(type_param.name))
                .map { |item| compile(item).as(String) }
            end
          end || %w[]

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
                  prefix(node, statement, "_._0"),
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
                  prefix(node, statement, "_._0"),
                ])
              end
            end
          when "Promise"
            if catches && !catches.empty?
              js.asynciif do
                js.try(prefix(node, statement, "await #{expression}"),
                  [js.catch("_error", js.statements(catches))],
                  "")
              end
            end
          end
        end || js.asynciif do
          prefix(node, statement, "await #{expression}")
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
        if node_finally = node.finally
          compile node_finally
        end

      then_block =
        if then_branch = node.then_branch
          js.assign("_", compile(then_branch.expression))
        end

      names =
        statements.compact_map do |statement|
          case target = statement.target
          when Ast::Variable
            js.let(js.variable_of(target), "null")
          when Ast::TupleDestructuring
            target.parameters.map do |variable|
              js.let(js.variable_of(variable), "null")
            end
          end
        end.flatten

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
