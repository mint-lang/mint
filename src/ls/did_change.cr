module Mint
  module LS
    class DidChange < LSP::NotificationMessage
      property params : LSP::DidChangeTextDocumentParams

      def execute(server)
        uri =
          URI.parse(params.text_document.uri)

        workspace =
          Workspace[uri.path.to_s]

        workspace.update(params.content_changes.first.text, uri.path)
      end
    end
  end
end
