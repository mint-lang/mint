module Mint
  module LS
    class Definitions
      def definition(node : Ast::HtmlComponent)
        return unless cursor_intersects?(node.component)

        return unless component =
                        find_component(node.component.value)

        location_link node.component, component.name, component
      end
    end
  end
end
