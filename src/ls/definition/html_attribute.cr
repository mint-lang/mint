module Mint
  module LS
    class Definition < LSP::RequestMessage
      def html_attribute(server : Server, workspace : Workspace, stack : Array(Ast::Node))
        return unless variable =
                        next_variable stack
        return unless html_attribute =
                        next_html_attribute stack
        return unless html_component =
                        next_html_component stack

        return unless component =
                        workspace.ast.components.find { |x| x.name == html_component.component.value }
        return unless component_property =
                        component.properties.find { |x| x.name.value == variable.value }

        location_link variable, component_property
      end
    end
  end
end
