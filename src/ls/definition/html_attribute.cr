module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::HtmlAttribute, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        return unless cursor_intersects?(node.name)

        return unless html_component = stack.find(&.is_a?(Ast::HtmlComponent)).as?(Ast::HtmlComponent)

        return unless component =
                        find_component(workspace, html_component.component.value)

        return unless component_property =
                        component.properties.find(&.name.value.== node.name.value)

        location_link server, node.name, component_property.name, component_property
      end
    end
  end
end
