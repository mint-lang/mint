module Mint
  class Cli < Admiral::Command
    class Start < Admiral::Command
      include Command

      define_help description: "Starts the development server."
      define_flag auto_format : Bool,
                  description: "Auto formats the source files when running development server.",
                  default: false,
                  required: false
      define_flag port : Int32,
                  description: "Change the port to serve the application on. (Default: 3000)",
                  long: port,
                  short: p,
                  default: 3000_i32,
                  required: false

      def run
        execute "Running the development server" do
          Reactor.start flags.auto_format, flags.port
        end
      end
    end
  end
end
