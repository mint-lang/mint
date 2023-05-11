module Mint
  class TypeChecker
    type_error ReturnTypeMismatch

    def check(node : Ast::Block) : Checkable
      statements =
        node.statements.select(Ast::Statement)

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

      if node.early_return?
        node.statements
          .select(Ast::Statement)
          .select!(&.return?).each do |item|
          case expression = item.expression
          when Ast::Operation
            type =
              cache[expression.right.as(Ast::ReturnCall).expression]

            raise ReturnTypeMismatch, {
              "node"     => expression.right,
              "expected" => last,
              "got"      => type,
            } unless Comparer.compare(last, type)
          end
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
