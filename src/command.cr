module Mint
  class Cli < Admiral::Command
    module Command
      include Errorable

      def execute(
        message : String,
        *,
        check_dependencies : Bool = false,
        env : String? = nil,
        & : -> T
      ) : T? forall T
        # On Ctrl+C and abort and exit.
        Process.on_terminate do
          terminal.puts
          terminal.divider
          terminal.puts "Aborted! Exiting..."
          exit(1)
        end

        # Print header and divider.
        terminal.header "Mint - #{message}"
        terminal.divider

        # Save terminal position in order to render divider in
        # case of an error.
        position =
          terminal.position

        # Have a variable for the result of the command.
        result = nil

        begin
          check_dependencies! if check_dependencies

          # Measure elapsed time of a command.
          elapsed = Time.measure { result = yield }
        rescue error : Error
          # In case of an error print it.
          error error.to_terminal, position
        rescue exception : Exception
          # In case of an exception print it.
          error exception.inspect_with_backtrace, position
        end

        # Format the elapsed time into a human readable format.
        formatted =
          TimeFormat.auto(elapsed).colorize.mode(:bold)

        # Print all done mssage.
        terminal.divider
        terminal.puts "All done in #{formatted}!"

        result
      end

      # Handles an error.
      def error(message, position)
        # Check if the command printed anything (last position of the IO is not
        # the current one).
        printed =
          terminal.position != position

        # If printed we need to print a divider.
        if printed
          terminal.puts
          terminal.divider
        end

        # If we have a message we need to print it and a divider.
        if message
          terminal.puts
          terminal.print message
          terminal.divider
        end

        terminal.puts "There was an error, exiting...".colorize.mode(:bold)

        # Exit with one to trigger failures in CI environments.
        exit(1)
      end

      def check_dependencies!
        MintJson.current.dependencies.each do |dependency|
          next if Dir.exists?(".mint/packages/#{dependency.name}")

          terminal.puts "#{COG} Ensuring dependencies..."
          terminal.puts " ↳ Not all dependencies in your mint.json file are installed."
          terminal.puts "   Would you like to install them now? (Y/n)"

          # Accept 'Y', 'y' or empty string (Enter) as affirmative response
          # Empty string is treated as 'Y' since Y is the default option
          answer = gets.to_s.strip.downcase
          terminal.puts AnsiEscapes::Erase.lines(2)

          if answer.empty? || answer == "y"
            Installer.new
            break
          else
            error "#{WARNING} Missing dependencies...", terminal.position
          end
        end
      end

      def terminal
        Render::Terminal::STDOUT
      end
    end
  end
end
