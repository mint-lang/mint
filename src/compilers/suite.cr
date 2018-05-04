module Mint
  class Compiler
    def compile(node : Ast::Suite)
      name =
        compile node.name

      tests =
        compile node.tests, ","

      "{ name: #{name}, tests: [#{tests}] }"
    end

    def compile(node : Ast::Test)
      rawExpression =
        node.expression

      name =
        compile node.name

      expression =
        case rawExpression
        when Ast::Operation
          if rawExpression.operator == "=="
            right =
              compile rawExpression.right

            left =
              compile rawExpression.left

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

      expression = compile rawExpression unless expression

      "{ name: #{name}, proc: () => { return #{expression} } }"
    end
  end
end
