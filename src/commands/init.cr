module Mint
  class Cli < Admiral::Command
    class Init < Admiral::Command
      include Command

      define_help description: "Initializes a new project."

      define_flag bare : Bool,
        description: "If speficied, an empty project will be generated.",
        default: false

      define_argument name,
        description: "The name of the new project."

      def run
        execute "Initializing a new project" do
          name = arguments.name.presence

          loop do
            terminal.puts "Please provide a name for the project (for example my-project):"
            break if name = gets.presence
          end unless name

          Scaffold.new(name: name, bare: flags.bare) if name
        end
      end
    end
  end
end
