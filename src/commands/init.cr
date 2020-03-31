module Mint
  class Cli < Admiral::Command
    class Init < Admiral::Command
      include Command

      define_help description: "Initializes a new project"

      define_argument name,
        description: "The name of the new project",
        required: false

      def run
        name = arguments.name || ""
        if !name.empty?
          execute "Initializing a new project" do
            Scaffold.run(name)
          end
        else
          execute "Please provide project name" do
            terminal.puts "Example: mint init my-project-name"
          end
        end
      end
    end
  end
end
