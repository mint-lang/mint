require "../reactor"

class Cli < Admiral::Command
  class Start < Admiral::Command
    define_help description: "Starts the development environment in the current directory."

    def run
      Reactor.start
    end
  end
end
