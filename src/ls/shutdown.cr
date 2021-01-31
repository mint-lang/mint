module Mint
  module LS
    class Shutdown < LSP::RequestMessage
      def execute(server)
        nil
      end
    end
  end
end
