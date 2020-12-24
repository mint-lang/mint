module Mint
  class Compiler
    protected def prefix(_node : Ast::Try, statement : Ast::Statement, value : Codegen::Node)
      case target = statement.target
      when Ast::Variable
        js.let(js.variable_of(target), value)
      when Ast::TupleDestructuring
        params =
          target.parameters.map { |param| js.variable_of(param) }

        variables =
          Codegen.join(params, ",")

        Codegen.join ["const [", variables, "] = ", value]
      else
        value
      end
    end

    def _compile(node : Ast::Try) : Codegen::Node
      _compile(node) { |statement| compile(statement) }
    end

    def _compile(node : Ast::Try, & : Ast::Statement, Int32, Bool -> Codegen::Node) : Codegen::Node
      catch_all =
        node.catch_all.try do |catch|
          Codegen.join [
            js.let("_catch_all",
              js.arrow_function([] of Codegen::Node,
                Codegen.join(["return ", compile(catch.expression)]))),
            "\n\n",
          ]
        end

      statements = node.statements
      statements_size = statements.size

      body =
        statements
          .sort_by { |item| resolve_order.index(item) || -1 }
          .map_with_index do |statement, index|
            is_last =
              (index + 1) == statements_size

            inner_prefix = ->(value : Codegen::Node) {
              if is_last
                Codegen.source_mapped(statement, Codegen.join ["return ", value])
              else
                prefix(node, statement, value)
              end
            }

            expression =
              yield statement, index, is_last

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
                          Codegen.join ["return ", catch_body],
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

            if catches && !Codegen.empty?(catches)
              js.statements([
                js.let("_#{index}", expression),
                js.if("_#{index} instanceof Err") do
                  js.statements([
                    js.let("_error", "_#{index}._0"),
                    catches,
                  ])
                end,
                inner_prefix.call("_#{index}._0"),
              ])
            else
              inner_prefix.call(expression)
            end
          end

      js.iif(Codegen.join [catch_all, js.statements(body)].compact)
    end
  end
end
