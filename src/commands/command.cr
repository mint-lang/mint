module Mint
  class Cli < Admiral::Command
    module Command
      def execute(message)
        # On Ctrl+C and abort and exit
        Signal::INT.trap do
          terminal.print "\n"
          terminal.divider
          terminal.print "Aborted! Exiting...\n"
          exit 1
        end

        # Print header and divider
        terminal.header "Mint - #{message}"
        terminal.divider

        # Save terminal position in order to render divider in
        # case of an error
        position =
          terminal.position

        begin
          # Measure elapsed time of a command
          elapsed = Time.measure { yield }
        rescue exception : Error
          # In case of an error print it
          error exception.to_terminal, position
        rescue CliException
          error nil, position
        end

        formatted =
          TimeFormat.auto(elapsed).colorize.mode(:bold)

        terminal.divider
        terminal.print "All done in #{formatted}!\n"
      end

      def error(message, position)
        printed =
          terminal.position != position

        if printed
          terminal.print "\n"
          terminal.divider
        end

        if message
          terminal.print "\n#{message}"
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
end
