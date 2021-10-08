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

      <<-JS
      ((constants) => {
        const context = new TestContext(#{left})
        const right = #{right}

        context.step((subject) => {
          if (#{"!" if operator == "=="}_compare(subject, right)) {
            throw `Assertion failed: ${right} #{operator} ${subject}`
          }
          return true
        })
        return context
      })(constants)
      JS
    end

    def unwrap_parenthesized_expression(node)
      while node.is_a?(Ast::ParenthesizedExpression)
        node = node.expression
      end
      node
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
        when Ast::Sequence
          _compile(raw_expression) do |statement, _index, is_last|
            if is_last
              exp =
                unwrap_parenthesized_expression(statement.expression)

              case exp
              when Ast::Operation
                if wrapped = _compile_operation_test(exp)
                  next wrapped
                end
              end
            end
            compile(statement)
          end
        end

      expression ||= compile(raw_expression)

      "{ name: #{name}, location: #{location}, proc: (constants) => { return #{expression} } }"
    end
  end
end
