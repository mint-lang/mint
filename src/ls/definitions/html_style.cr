module Mint
  module LS
    class Definitions
      def definition(node : Ast::HtmlStyle)
        return unless cursor_intersects?(node.name)

        return unless component =
                        @stack.find(&.is_a?(Ast::Component)).as?(Ast::Component)

        return unless component_style =
                        component.styles.find(&.name.value.== node.name.value)

        location_link node.name, component_style.name, component_style
      end
    end
  end
end
