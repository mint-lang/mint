module Mint
  class Compiler
    def _compile(node : Ast::Sequence) : String
      body = node.statements.map_with_index do |statement, index|
        prefix =
          case
          when (index + 1) == node.statements.size
            "_result ="
          when name = statement.name
            "let #{name.value} ="
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
                .join("\n")
            end
          end

        case type
        when TypeChecker::Type
          case type.name
          when "Result"
            if catches && catches.empty?
              <<-JS
              let _#{index} = #{expression}

              if (_#{index} instanceof Err) {
                throw _#{index}.value
              }

              #{prefix} _#{index}.value
              JS
            else
              <<-JS
              let _#{index} = #{expression}

              if (_#{index} instanceof Err) {
                let _error = _#{index}.value

                #{catches}
              }

              #{prefix} _#{index}.value
              JS
            end
          when "Promise"
            if catches && !catches.empty?
              <<-JS
              #{prefix} await (async () => {
                try {
                  return await #{expression}
                } catch (_error) {
                  #{catches}
                }
              })()
              JS
            end
          end
        end || "#{prefix} await #{expression}"
      end.join("\n\n").indent

      catch_all =
        node.catch_all.try do |catch|
          "_result = #{compile catch.expression}"
        end || <<-JS
          console.warn(`Unhandled error in sequence expression:`)
          console.warn(_error)
        JS

      finally =
        if node.finally
          compile node.finally.not_nil!
        end

      <<-JS
      (async () => {
        let _result = null;

        try {
        #{body}
        }
        catch (_error) {
          if (_error instanceof DoError) {} else {
            #{catch_all}
          }
        } #{finally}

        return _result
      })()
      JS
    end
  end
end
