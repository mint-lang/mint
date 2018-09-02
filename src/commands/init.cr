module Mint
  class Cli < Admiral::Command
    class Init < Admiral::Command
      include Command

      define_help description: "Initializes a new project"

      define_argument name,
        description: "The name of the new project",
        required: false

      def run
        if arguments.name
          execute "Initializing a new project" do
            Scaffold.run(arguments.name || ".")
          end
        else
          execute "Initializing a new project in current directory" do
            Scaffold.run(".")
          end
        end
      end
    end
  end
end
