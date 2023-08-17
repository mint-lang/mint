module Mint
  class TypeChecker
    def check(node : Ast::Route) : Checkable
      args = node.arguments.map do |argument|
        argument_type =
          resolve argument

        error :route_param_invalid do
          block do
            text "The type of parameter "
            bold argument.name.value
            text "cannot be used in routes."
          end

          snippet argument_type
          snippet "Only these types can be used as route params:", "String, Number"
          snippet argument
        end unless Comparer.matches_any?(argument_type, [STRING, NUMBER])

        {argument.name.value, argument_type, argument}
      end

      scope args do
        resolve node.expression
      end
    end
  end
end
