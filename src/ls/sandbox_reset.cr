module Mint
  module LS
    class SandboxReset < LSP::RequestMessage
      property params : Array(Tuple(String, String))

      def execute(server : Server)
        if sandbox = server.sandbox
          sandbox.reset(params)
          sandbox.directory
        end
      end
    end
  end
end
