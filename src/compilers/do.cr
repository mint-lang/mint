module Mint
  class Compiler
    def compile(node : Ast::Do) : String
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

        if catches && type
          if type.name == "Promise"
            <<-RESULT
            #{prefix} await (async ()=> {
              try {
                return await #{expression}
              } catch(_error) {
                #{catches}
              }
            })()
            RESULT
          else
            <<-RESULT
            let _#{index} = #{expression}

            if (_#{index} instanceof Err) {
              let _error = _#{index}.value

              #{catches}
            }

            #{prefix} _#{index}.value
            RESULT
          end
        else
          "#{prefix} await #{expression}"
        end
      end.join("\n\n")

      finally =
        if node.finally
          compile node.finally.not_nil!
        end

      <<-RESULT
      (async () => {
        let _result = null;

        try {
          #{body}
        }
        catch(_error) {
          if (_error instanceof DoError) {} else {
            console.warn(`Unhandled error in do statement`)
            console.log(_error)
          }
        } #{finally}

        return _result
      })()
      RESULT
    end
  end
end
