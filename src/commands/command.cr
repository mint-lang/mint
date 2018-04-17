class Cli < Admiral::Command
  module Command
    def execute(message)
      puts "Mint 1.0.0 - #{message}"
      puts Terminal.separator

      elapsed = Time.measure { yield }

      puts Terminal.separator
      puts "All done in #{TimeFormat.auto(elapsed).colorize.mode(:bold).to_s}!"
    rescue exception : MintJson::Error | SyntaxError | TypeError
      puts "\n"
      puts Terminal.separator
      puts "\n" + exception.message.to_s
      puts Terminal.separator
      puts "There was an error exiting...".colorize.mode(:bold).to_s
      exit 1
    rescue CliException
      puts Terminal.separator
      puts "There was an error exiting..."
      exit 1
    end
  end
end
