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
      client = Socket.tcp(Socket::Family::INET, true)
      client.connect(ip, port, 0.25)
      client.close
      false
    rescue
      true
    end

    def run(name : String, host : String = "127.0.0.1", port : Int32 = 3000)
      config = Kemal.config
      config.logger = Logger.new
      config.setup

      if port_open?(host, port)
        server = HTTP::Server.new(config.handlers)
        terminal.print "#{COG} #{name} server started on http://#{host}:#{port}/\n"
      elsif STDIN.tty?
        new_port = config.port + 1
        until port_open?(host, new_port)
          new_port = new_port + 1
        end
        terminal.print "#{COG} Port #{port} is used by a different application!\n"
        terminal.print "#{COG} Would you like to to use port #{new_port} instead? (Y/n)\n"

        use_new_port = gets
        if !use_new_port.nil? && use_new_port.downcase == "y"
          run(name, host, new_port)
        else
          terminal.print "#{COG} Exiting...\n"
        end
      else
        terminal.print "#{COG} Port #{port} is used by a different application!\n"
        exit 1
      end

      config.server = server
      config.running = true
      config.server.try(&.listen(host, port))
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
