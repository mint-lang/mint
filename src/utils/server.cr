module Mint
  # This module contains the logic to present the user with an option to
  # run a server on a different port if the original is in use.
  module Server
    extend self

    def run(
      *,
      host : String = "127.0.0.1",
      server : HTTP::Server,
      port : Int32 = 3000,
      &callback : Proc(String, Int32, Nil)
    )
      if port_closed?(host, port)
        if STDIN.tty?
          terminal.puts "#{COG} Port #{port} is used by a different application!"

          while port_closed?(host, port)
            port += 1
          end

          terminal.puts "#{COG} Would you like to to use port #{port} instead? (Y/n)"

          unless gets.to_s.downcase.downcase == "y"
            terminal.puts "#{COG} Exiting..."
            exit(1)
          end
        else
          terminal.puts "#{COG} Port #{port} is used by a different application!"
          exit(1)
        end
      end

      callback.call(host, port)

      server.bind_tcp(host, port)
      server.listen
    end

    private def port_closed?(host, port)
      client = Socket.tcp(Socket::Family::INET, true)
      client.connect(host, port, 0.25)
      client.close
      true
    rescue
      false
    end

    private def terminal
      Render::Terminal::STDOUT
    end
  end
end
