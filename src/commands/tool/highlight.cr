module Mint
  class Cli < Admiral::Command
    class Highlight < Admiral::Command
      include Command

      define_help description: "Returns the syntax highlighted version of the given file."

      define_flag html : Bool,
        description: "If specified, print the highlighted code as HTML.",
        default: false

      define_argument path, description: "The path to the file.",
        required: true

      def run
        if File.file?(arguments.path)
          puts SemanticTokenizer.highlight(arguments.path, html: flags.html)
        else
          execute "Highlighting" do
            puts %(#{WARNING} File "#{arguments.path.colorize.bold}" not found.)
            terminal.divider
            error nil, terminal.position
          end
        end
      end
    end
  end
end
