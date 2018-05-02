module Mint
  class Cli < Admiral::Command
    class Init < Admiral::Command
      include Command

      define_help description: "Initializes a new project"

      define_argument name,
        description: "The name of the new project",
        required: true

      def run
        execute "Initializing new project" do
          Scaffold.run(arguments.name)
        end
      end
    end
  end
end
