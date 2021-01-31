module Mint
  module LS
    class Exit < LSP::NotificationMessage
      def execute(server)
        exit(0)
      end
    end
  end
end
