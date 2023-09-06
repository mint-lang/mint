module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::HtmlComponent, workspace : Workspace, stack : Array(Ast::Node))
        return unless cursor_intersects?(node.component)

        return unless component =
                        find_component(workspace, node.component.value)

        location_link node.component, component.name, component
      end
    end
  end
end
