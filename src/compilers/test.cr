module Mint
  class Compiler
    def _compile(node : Ast::Test) : String
      name =
        compile node.name

      location =
        node.location.to_json

      raw_expression =
        node.expression

      expression =
        case raw_expression
        when Ast::Operation
          if raw_expression.operator == "=="
            right =
              compile raw_expression.right

            left =
              compile raw_expression.left

            <<-JS
            ((constants) => {
              const context = new TestContext(#{left})
              const right = #{right}

              context.step((subject) => {
                if (!_compare(subject, right)) {
                  throw `Assertion failed: ${right} != ${subject}`
                }
                return true
              })
              return context
            })(constants)
            JS
          end
        end

      expression ||= compile(raw_expression)

      "{ name: #{name}, location: #{location}, proc: (constants) => { return #{expression} } }"
    end
  end
end
