module Mint
  module LS
    class CodeAction < LSP::RequestMessage
      property params : LSP::CodeActionParams

      def actions(node : Ast::Module)
        [
          ModuleActions.order_entities(node, workspace, params.text_document.uri),
        ]
      end

      def actions(node : Ast::Node)
        [] of LSP::CodeAction
      end

      def execute(server)
        if workspace.error
          [] of LSP::CodeAction
        else
          server
            .nodes_at_cursor(params)
            .reduce([] of LSP::CodeAction) do |memo, node|
              memo + actions(node)
            end
        end
      end

      private def workspace
        Workspace[params.text_document.path]
      end
    end
  end
end
