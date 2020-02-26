module Mint
  class TypeChecker
    type_error RouteParamInvalid

    def check(node : Ast::Route) : Checkable
      args = node.arguments.map do |argument|
        argument_type =
          resolve argument

        raise RouteParamInvalid, {
          "name" => argument.name.value,
          "got"  => argument_type,
          "node" => argument,
        } unless Comparer.matches_any?(argument_type, [STRING, NUMBER])

        {argument.name.value, argument_type, argument}
      end

      scope args do
        resolve node.expression
      end
    end
  end
end
