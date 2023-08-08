module Mint
  class TypeChecker
    def check(node : Ast::Route) : Checkable
      node.arguments.map do |argument|
        type =
          resolve argument

        error! :route_param_invalid do
          snippet "The type of a route parameter cannot be used in routes:", argument.type
          snippet "Only these types can be used as route parameters:", "String\nNumber"
        end if type.is_a?(Variable) ||
               !Comparer.matches_any?(type, [STRING, NUMBER])

        {argument.name.value, type, argument}
      end

      resolve node.expression
    end
  end
end
