module Mint
  class TypeChecker
    def check(node : Ast::Block) : Checkable
      if node.expressions.all?(Ast::CssDefinition)
        resolve node.expressions
        VOID
      else
        expressions =
          node.expressions.select(Ast::Statement)

        error! :block_no_expressions do
          block "This block doesn't have any statements. It should have at least one."
          snippet node
        end if expressions.empty?

        expressions.dup.tap do |items|
          variables = [] of VariableScope

          while item = items.shift?
            variables.each do |var|
              scope.add(node, var[0], var[2])
            end

            # This is to allow recursion
            case target = item.target
            when Ast::Variable
              case value = item.expression
              when Ast::InlineFunction
                cache[target] =
                  static_type_signature(value)

                scope.add(item, target.value, target)
              end
            end

            type = resolve item
            variables = destructure(item.target, type)
          end
        end

        last =
          cache[expressions.last]

        error! :statement_last_target do
          block do
            text "The"
            bold "last statement"
            text "of a block cannot be an"
            bold "assignment:"
          end

          snippet node
        end if expressions.last.target

        node.returns.each do |item|
          type =
            cache[item]

          error! :statement_return_type_mismatch do
            snippet "The type of a return call does not match the return " \
                    "type of the block:", type

            snippet "I was expecting:", last
            snippet "It return call in question is here:", item
            snippet "The returned value of the block is here:", expressions.last
          end unless Comparer.compare(last, type)
        end

        if async?(node) && last.name != "Promise"
          Type.new("Promise", [last] of Checkable)
        else
          last
        end
      end
    end
  end
end
