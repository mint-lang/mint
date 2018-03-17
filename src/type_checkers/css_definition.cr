class TypeChecker
  type_error CssDefinitionTypeMismatch

  def check(node : Ast::CssDefinition) : Type
    node.value.each do |item|
      type =
        case item
        when Ast::CssInterpolation
          check item
        else
          STRING
        end

      raise CssDefinitionTypeMismatch, {
        "property" => node.name,
        "node"     => node,
        "got"      => type,
      } unless Comparer.compare(type, STRING) ||
               Comparer.compare(type, NUMBER)
    end

    NEVER
  end
end
