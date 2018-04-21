class Cli < Admiral::Command
  module Command
    def execute(message)
      terminal.header "Mint 1.0.0 - #{message}"
      terminal.divider

      position =
        terminal.position

      begin
        elapsed =
          Time.measure { yield }
      rescue exception : SyntaxError | TypeError
        error exception.message.to_s, position
      rescue exception : MintJson::Error
        message =
          Render::Terminal.render do
            title "MINT.JSON ERROR"
            block do
              text exception.message.to_s
            end
            title_divider
          end

        error message, position
      rescue CliException
        error nil, position
      end

      formatted =
        TimeFormat.auto(elapsed).colorize.mode(:bold)

      terminal.divider
      terminal.print "All done in #{formatted}!"
    end

    def error(message, position)
      printed =
        terminal.position != position

      if printed
        terminal.divider
      end

      if message
        terminal.print "\n#{message}\n"
        terminal.divider
      end

      terminal.print "There was an error exiting...\n".colorize.mode(:bold)
      exit 1
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
