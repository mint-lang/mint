module Mint
  class Cli < Admiral::Command
    class Format < Admiral::Command
      include Command

      define_help description: "Formats source files"

      define_argument pattern,
        description: "The pattern which determines which files to format",
        default: "source/**/*.mint"

      def run
        execute "Formatting files" do
          files = Dir.glob(arguments.pattern.to_s)

          if files.empty?
            terminal.puts "Nothing to format!"
          else
            results =
              files.map do |file|
                artifact =
                  Parser.parse(file)

                formatted =
                  Formatter.new(artifact, MintJson.parse_current.formatter_config).format

                if formatted != File.read(file)
                  File.write(file, formatted)
                  terminal.puts "Formatted: #{file}"
                  true
                end
              end.compact

            terminal.puts "All files are formatted!" if results.empty?
          end
        end
      end
    end
  end
end
