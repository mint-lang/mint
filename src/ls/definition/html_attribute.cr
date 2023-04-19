module Mint
  module LS
    class Definition < LSP::RequestMessage
      def html_attribute(server : Server, workspace : Workspace, stack : Array(Ast::Node))
        with_stack(stack) do |reader|
          return unless variable =
                          reader.find_next Ast::Variable

          return unless reader.find_next Ast::HtmlAttribute

          return unless html_component =
                          reader.find_next Ast::HtmlComponent

          return unless component =
                          workspace.ast.components.find { |x| x.name == html_component.component.value }
          return unless component_property =
                          component.properties.find { |x| x.name.value == variable.value }

          location_link server, variable, component_property
        end
      end
    end
  end
end
