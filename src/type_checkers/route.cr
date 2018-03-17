class TypeChecker
  type_error RouteNotVoid

  def check(node : Ast::Route) : Type
    args = node.arguments.map do |argument|
      {argument.name.value, check argument.type}
    end

    scope args do
      type = check node.expression

      raise RouteNotVoid, {
        "got"  => type,
        "node" => node,
      } unless Comparer.compare(type, VOID)

      type
    end
  end
end
