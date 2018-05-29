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

    def port_open?(ip, port)
      TCPSocket.new(ip, port).close
      false
    rescue
      true
    end

    def run(port : Int32 = 3000)
      config = Kemal.config
      config.logger = Logger.new
      config.setup

      if port_open?(config.host_binding, port)
        server =
          HTTP::Server.new(config.host_binding, port, config.handlers)
        terminal.print "#{COG} Development server started on http://#{config.host_binding}:#{port}/\n"
      else
        new_port = config.port + 1
        until port_open?(config.host_binding, new_port)
          new_port = new_port + 1
        end
        terminal.print "#{COG} Port #{port} is used by a different application!\n"
        terminal.print "#{COG} Would you like to to use port #{new_port} instead? (Y/n)\n"

        use_new_port = gets
        if use_new_port.downcase == "y"
          run(new_port)
        else
          terminal.print "#{COG} Exiting...\n"
        end
      end

      config.server = server
      config.running = true
      config.server.try(&.listen)
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
