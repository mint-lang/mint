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

    def run(name, host = "127.0.0.1", port = 3000, browser_host = "127.0.0.1", browser_port = 3000)
      config = Kemal.config
      config.logger = Logger.new
      config.setup

      if port_open?(host, port)
        server = HTTP::Server.new(config.handlers)
        terminal.puts "#{COG} #{name} server started on http://#{host}:#{port}/"

        if browser_host != host || browser_port != port
          terminal.puts "  Also available here http://#{browser_host}:#{browser_port || port}/"
        end
      elsif STDIN.tty?
        new_port = config.port + 1
        until port_open?(host, new_port)
          new_port = new_port + 1
        end
        terminal.puts "#{COG} Port #{port} is used by a different application!"
        terminal.puts "#{COG} Would you like to to use port #{new_port} instead? (Y/n)"

        use_new_port = gets
        if !use_new_port.nil? && (use_new_port.empty? || use_new_port.downcase == "y")
          run(name, host, new_port, browser_host, browser_port)
        else
          terminal.puts "#{COG} Exiting..."
        end
      else
        terminal.puts "#{COG} Port #{port} is used by a different application!"
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
