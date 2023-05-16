module Mint
  class TypeChecker
    type_error StatementLastTarget
    type_error ReturnCallTypeMismatch

    def check(node : Ast::Block) : Checkable
      statements =
        node.statements.select(Ast::Statement)

      with_returns(node) do
        statements.dup.tap do |items|
          variables = [] of VariableScope

          while item = items.shift?
            # This is to allow recursion
            case target = item.target
            when Ast::Variable
              case value = item.expression
              when Ast::InlineFunction
                variables << {target.value, static_type_signature(value), target}
              end
            end

            scope variables do
              type = resolve item
              variables.concat(destructure(item.target, type))
            end
          end
        end

        last =
          cache[statements.last]

        raise StatementLastTarget, {
          "node" => node,
        } if statements.last.target

        if returns = @returns[node]?
          returns.each do |item|
            type =
              cache[item]

            raise ReturnCallTypeMismatch, {
              "node"     => item,
              "expected" => last,
              "got"      => type,
            } unless Comparer.compare(last, type)
          end
        end

        if node.async? && last.name != "Promise"
          Type.new("Promise", [last] of Checkable)
        else
          last
        end
      end
    end
  end
end
