class Compiler
  def compile(node : Ast::Try) : String
    body = node.statements.map_with_index do |statement, index|
      prefix =
        case
        when (index + 1) == node.statements.size
          "return"
        when name = statement.name
          "let #{name.value} ="
        end

      expression =
        compile statement

      type = types[statement]?

      catches =
        case type
        when TypeChecker::Type
          if type.name == "Result" && type.parameters[0]
            node.catches.map do |catch|
              if catch.type == type.parameters[0].name
                catch_body =
                  compile catch.expression

                variable =
                  catch.variable.value

                "let #{variable} = _error\n return #{catch_body}"
              else
                ""
              end
            end.join("\n\n")
          end
        end

      if catches && !catches.empty?
        "let _#{index} = #{expression}

         if (_#{index} instanceof Err) {
            let _error = _#{index}.value
            #{catches}
         }

         #{prefix} _#{index}.value"
      else
        "#{prefix} #{expression}"
      end
    end.join("\n\n")

    "(() => { #{body} })()"
  end
end
