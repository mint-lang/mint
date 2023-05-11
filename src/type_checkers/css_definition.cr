module Mint
  class TypeChecker
    CSS_PROPERTY_NAMES =
      {{ read_file("#{__DIR__}/../assets/css_properties") }}
        .strip
        .lines

    type_error CssDefinitionTypeMismatch
    type_error CssNoProperty

    def check(node : Ast::CssDefinition) : Checkable
      node.value.each do |item|
        type =
          case item
          when Ast::Node
            resolve item
          else
            STRING
          end

        unless node.name.starts_with?('-')
          raise CssNoProperty, {
            "name" => node.name,
            "node" => node,
          } unless CSS_PROPERTY_NAMES.includes?(node.name)
        end

        raise CssDefinitionTypeMismatch, {
          "name" => node.name,
          "node" => node,
          "got"  => type,
        } unless Comparer.matches_any?(type, [STRING, NUMBER])
      end

      VOID
    end
  end
end
