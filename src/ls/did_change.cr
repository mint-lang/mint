module Mint
  module LS
    class DidChange < LSP::NotificationMessage
      property params : LSP::DidChangeTextDocumentParams

      def execute(server) : Nil
        path =
          params.text_document.path

        server
          .workspace(path)
          .update(params.content_changes.first.text, path)
      end
    end
  end
end
