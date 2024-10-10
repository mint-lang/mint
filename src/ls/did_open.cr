module Mint
  module LS
    class DidOpen < LSP::NotificationMessage
      property params : LSP::DidOpenTextDocumentParams

      def execute(server) : Nil
        path =
          params.text_document.path

        server
          .workspace(path)
          .update(params.text_document.text, path)
      end
    end
  end
end
