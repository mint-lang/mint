module Mint
  class Compiler
    def _compile(node : Ast::Test) : String
      raw_expression =
        node.expression

      name =
        compile node.name

      expression =
        case raw_expression
        when Ast::Operation
          if raw_expression.operator == "=="
            right =
              compile raw_expression.right

            left =
              compile raw_expression.left

            "(() => {
            const context = new TestContext(#{left})
            const right = #{right}

            context.step((subject) => {
              if (_compare(subject, right)) {
                return true
              } else {
                throw \`Assertion failed ${right.toString()} != ${subject.toString()}\`
              }
            })
            return context
          })()"
          end
        end

      expression = compile raw_expression unless expression

      "{ name: #{name}, proc: () => { return #{expression} } }"
    end
  end
end
