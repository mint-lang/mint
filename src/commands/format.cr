module Mint
  class Cli < Admiral::Command
    class Format < Admiral::Command
      include Command

      define_help description: "Formats source files"

      define_argument pattern,
        description: "The pattern which determines which files to format"

      def run
        execute "Formatting files" do
          if arguments.pattern.to_s.empty?
            files = Dir.glob(["tests/**/*.mint", "source/**/*.mint"])
          else
            files = Dir.glob(arguments.pattern.to_s)
          end

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
        rescue
          puts %(I was looking for a pattern that contains ".mint" files,)
          puts %(such as "source/**/*.mint". Got "#{arguments.pattern}" instead.)
        end
      end
    end
  end
end
