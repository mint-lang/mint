module Mint
  class Cli < Admiral::Command
    class Highlight < Admiral::Command
      include Command

      define_help description: "Returns the syntax highlighted version of the given file."

      define_argument path, description: "The path to the file."

      define_flag html : Bool,
        description: "If specified, print the highlighted code as HTML.",
        default: false

      def run
        return unless path = arguments.path
        puts SemanticTokenizer.highlight(path, flags.html)
      end
    end
  end
end
