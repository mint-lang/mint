module Mint
  class TypeChecker
    def check(node : Ast::CaseBranch, condition : Checkable) : Checkable
      case patterns = node.patterns
      when Array(Ast::Node)
        patterns
          .map { |item| destructure(item, condition) }
          .reduce do |first, item|
            error! :missing_variable_in_alternative_pattern do
              snippet "All alternative patterns must define the same " \
                      "variables as the initial pattern, but one does " \
                      "not have all of them:", node
            end unless first.map(&.first).sort! == item.map(&.first).sort!

            first
          end
          .each do |var|
            scope.add(node, var[0], var[2])
          end
      end

      type =
        resolve(node.expression)

      if node.expression.is_a?(Array(Ast::CssDefinition))
        VOID
      else
        type.as(Checkable)
      end
    end
  end
end
