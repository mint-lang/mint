module Mint
  class Compiler
    def _compile_operation_test(operation : Ast::Operation) : String?
      operator =
        operation.operator

      return unless operator.in?("==", "!=")

      right =
        compile operation.right

      left =
        compile operation.left

      <<-COMPILED
      (() => {
        const context = new TestContext(#{left})
        const right = #{right}

        context.step((subject) => {
          if (#{"!" if operator == "=="}_compare(subject, right)) {
            throw `Assertion failed: ${right} #{operator} ${subject}`
          }
          return true
        })
        return context
      })()
      COMPILED
    end

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
          _compile_operation_test(raw_expression)
        end || compile(raw_expression)

      js.object({
        "proc"     => "async function () { return #{expression} }",
        "location" => location,
        "name"     => name,
      })
    end
  end
end
