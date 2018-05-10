module Mint
  # This is a basic Kemal server without option parsing and logging.
  module Server
    extend self

    class Logger < Kemal::BaseLogHandler
      def call(context)
        call_next context
      end

      def write(message)
      end
    end

    def run
      config = Kemal.config
      config.logger = Logger.new
      config.setup

      server =
        HTTP::Server.new(config.host_binding, config.port, config.handlers)

      config.server = server
      config.running = true
      config.server.try(&.listen)
    end
  end
end
