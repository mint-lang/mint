class Compiler
  def compile(node : Ast::Do) : String
    body = node.statements.map_with_index do |statement, index|
      prefix =
        case
        when name = statement.name
          "let #{name.value} ="
        end

      expression =
        compile statement.expression

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
          "#{prefix} await (async ()=> {
            try {
              return await #{expression}
            } catch(_error) {
              #{catches}

              throw new DoError
            }})()"
        else
          "let _#{index} = #{expression}

          if (_#{index} instanceof Err) {
            let _error = _#{index}.value
            #{catches}

            throw new DoError
          }

          #{prefix} _#{index}.value
          "
        end
      else
        "#{prefix} await #{expression}"
      end
    end.join("\n\n")

    finally =
      if node.finally
        compile node.finally.not_nil!
      end

    "(async () => {
        try { #{body} }
        catch(_error) {
          if (_error instanceof DoError) {
          } else {
            console.warn(`Unhandled error in do statement`)
            console.log(_error)
          }
        } #{finally}
      })()"
  end
end
