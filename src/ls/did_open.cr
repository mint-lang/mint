module Mint
  module LS
    class DidOpen < LSP::NotificationMessage
      property params : LSP::DidOpenTextDocumentParams

      def execute(server)
        uri =
          URI.parse(params.text_document.uri)

        workspace =
          server.workspace(uri)

        workspace.update(params.text_document.text, uri.path)
      end
    end
  end
end
