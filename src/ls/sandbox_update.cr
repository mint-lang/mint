module Mint
  module LS
    class SandboxUpdate < LSP::RequestMessage
      property params : Tuple(String, String)

      def execute(server : Server)
        server.sandbox.try(&.update(params))
      end
    end
  end
end
