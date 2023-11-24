module Mint
  class TypeChecker
    CSS_PROPERTY_NAMES =
      {{ read_file("#{__DIR__}/../assets/css_properties").strip.lines }}

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
          error! :css_definition_no_property do
            block do
              text "There is no CSS property with the name:"
              bold %("#{node.name}")
            end

            snippet node
          end unless CSS_PROPERTY_NAMES.includes?(node.name)
        end

        error! :css_definition_type_mismatch do
          block do
            text "The type of the value for the CSS property"
            bold %("#{node.name}")
            text "is invalid."
          end

          snippet "I was expecting one of these types:", "String\nNumber"
          snippet "Instead it is:", type
          snippet "The css definition in question is here:", node
        end unless Comparer.matches_any?(type, [STRING, NUMBER])
      end

      VOID
    end
  end
end
