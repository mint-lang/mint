module Mint
  class TypeChecker
    type_error CssDefinitionTypeMismatch

    def check(node : Ast::CssDefinition) : Type
      node.value.each do |item|
        type =
          case item
          when Ast::CssInterpolation
            resolve item
          else
            STRING
          end

        raise CssDefinitionTypeMismatch, {
          "name" => node.name,
          "node" => node,
          "got"  => type,
        } unless Comparer.compare(type, STRING) ||
                 Comparer.compare(type, NUMBER)
      end

      NEVER
    end
  end
end
