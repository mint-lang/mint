module Mint
  module LS
    class CodeAction < LSP::RequestMessage
      property params : LSP::CodeActionParams

      def actions(node : Ast::Provider, workspace : FileWorkspace)
        [
          ProviderActions.order_entities(
            node, workspace, params.text_document.uri),
        ]
      end

      def actions(node : Ast::Module, workspace : FileWorkspace)
        [
          ModuleActions.order_entities(
            node, workspace, params.text_document.uri),
        ]
      end

      def actions(node : Ast::Node, workspace : FileWorkspace)
        [] of LSP::CodeAction
      end

      def execute(server : LSP::Server)
        workspace =
          server.workspace(params.text_document.path)

        nodes =
          workspace.nodes_at_cursor(
            column: params.range.start.character,
            line: params.range.start.line + 1,
            path: params.text_document.path)

        case nodes
        in Error
          [] of LSP::CodeAction
        in Array(Ast::Node)
          nodes.reduce([] of LSP::CodeAction) do |memo, node|
            memo + actions(node, workspace)
          end
        end
      end
    end
  end
end
