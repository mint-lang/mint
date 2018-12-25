module Mint
  class Compiler
    def _compile(node : Ast::Try) : String
      catch_all =
        node.catch_all.try do |catch|
          "let _catch_all = (() => { return #{compile(catch.expression)} })\n\n"
        end

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
              catched =
                node.catches.map do |catch|
                  if catch.type == type.parameters[0].name
                    catch_body =
                      compile catch.expression

                    variable =
                      catch.variable.value

                    "let #{variable} = _error\n return #{catch_body}"
                  end
                end

              if catched.any?
                catched.join("\n\n")
              else
                "return _catch_all()"
              end
            end
          end

        if catches && !catches.empty?
          <<-JS
          let _#{index} = #{expression};

          if (_#{index} instanceof Err) {
             let _error = _#{index}.value
             #{catches}
          }

          #{prefix} _#{index}.value;
          JS
        else
          "#{prefix} #{expression}"
        end
      end.join("\n\n")

      "(() => { #{catch_all}#{body} })()"
    end
  end
end
