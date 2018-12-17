module Mint
  class Cli < Admiral::Command
    module Command
      macro included
        define_flag env : String,
          description: "Loads the given .env file",
          default: "",
          long: "env",
          short: "e"
      end

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
          # Load environment variables
          Env.init(flags.env) do |file|
            terminal.puts "#{COG} Loaded environment variables from: #{file}"
          end

          # Measure elapsed time of a command
          elapsed = Time.measure { yield }
        rescue exception : Error
          # In case of an error print it
          error exception.to_terminal, position
        rescue CliException
          # In case of a CLI expection just exit
          error nil, position
        end

        # Format the elapsed time into a uman readable format
        formatted =
          TimeFormat.auto(elapsed).colorize.mode(:bold)

        # Print all done mssage
        terminal.divider
        terminal.print "All done in #{formatted}!\n"
      end

      # Handles an error
      def error(message, position)
        # Check if the command printed anything (last position of the IO is not
        # the current one)
        printed =
          terminal.position != position

        # If printed we need to print a divider
        if printed
          terminal.print "\n"
          terminal.divider
        end

        # If we have a message we need to print it and a divider
        if message
          terminal.print "\n#{message}"
          terminal.divider
        end

        terminal.print "There was an error exiting...\n".colorize.mode(:bold)

        # Exit with one to trigger faliures in CI environments
        exit 1
      end

      def terminal
        Render::Terminal::STDOUT
      end
    end
  end
end
