module Mint
  module LS
    class ApplyEdit < LSP::NotificationMessage
      property params : LSP::ApplyWorkspaceEditParams

      def execute(server : Server)
        puts params.edit.changes
        puts params.edit.document_changes
      end
    end
  end
end
