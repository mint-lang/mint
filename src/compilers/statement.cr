module Mint
  class Compiler
    def _compile2(node : Ast::Statement) : Array(String)
      right, return_call =
        case expression = node.expression
        when Ast::Operation
          case item = expression.right
          when Ast::ReturnCall
            {
              compile(expression.left),
              compile(item.expression),
            }
          end
        end || {compile(node.expression), nil}

      right = "await #{right}" if node.await

      if target = node.target
        case target
        when Ast::Variable
          [js.const(js.variable_of(target), right)]
        when Ast::TupleDestructuring, Ast::TypeDestructuring, Ast::ArrayDestructuring
          variables = [] of String

          pattern =
            destructuring(target, variables)

          case target
          when Ast::TupleDestructuring
            if target.items.all?(Ast::Variable)
              ["const [#{variables.join(",")}] = #{right}"]
            end
          end || begin
            var, const =
              js.const("__match(#{right}, #{pattern})")

            return_if =
              if return_call
                js.if("#{var} === false", js.return(return_call))
              end

            [
              const,
              return_if,
              "const [#{variables.join(",")}] = #{var}",
            ].compact
          end
        end
      end || [right]
    end
  end
end
