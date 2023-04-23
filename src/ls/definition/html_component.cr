module Mint
  module LS
    class Definition < LSP::RequestMessage
      def html_component(server : Server, workspace : Workspace, stack : Array(Ast::Node))
        with_stack(stack) do |reader|
          return unless type_id = reader.find_next Ast::TypeId

          return unless html_component = reader.find_next Ast::HtmlComponent

          return unless component =
                          find_component(workspace, html_component.component.value)

          location_link server, type_id, component
        end
      end
    end
  end
end
