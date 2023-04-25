module Mint
  module LS
    class Definition < LSP::RequestMessage
      def html_style(server : Server, workspace : Workspace, stack : Array(Ast::Node))
        with_stack(stack) do |reader|
          return unless variable =
                          reader.find_next Ast::Variable

          return unless reader.find_next Ast::HtmlStyle

          return unless component =
                          reader.find_anywhere Ast::Component

          return unless component_style = component.styles.find { |x| x.name.value == variable.value }

          location_link server, variable, component_style
        end
      end
    end
  end
end
