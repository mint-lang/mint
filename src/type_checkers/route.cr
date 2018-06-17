module Mint
  class TypeChecker
    type_error RouteNotVoid

    def check(node : Ast::Route) : Checkable
      args = node.arguments.map do |argument|
        {argument.name.value, resolve(argument.type).as(Checkable)}
      end

      scope args do
        type = resolve node.expression

        raise RouteNotVoid, {
          "got"  => type,
          "node" => node,
        } unless Comparer.compare(type, VOID)

        type
      end
    end
  end
end
