class Cli < Admiral::Command
  module Command
    def execute(message)
      puts "Mint 1.0.0 - #{message}"
      puts Terminal.separator

      elapsed = Time.measure { yield }

      puts Terminal.separator
      puts "All done in #{TimeFormat.auto(elapsed).colorize.mode(:bold).to_s}!"
    rescue CliException
      puts Terminal.separator.colorize(:light_red)
      puts "There was an error exiting...".colorize(:light_red)
      exit 1
    end
  end
end
