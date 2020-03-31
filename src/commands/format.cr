module Mint
  class Cli < Admiral::Command
    class Format < Admiral::Command
      include Command

      define_help description: "Formats source files"

      define_argument pattern,
        description: "The pattern which determines which files to format"

      def run
        execute "Formatting files" do
          current =
            MintJson.parse_current

          format_directories =
            current.source_directories | current.test_directories

          format_directories_patterns =
            format_directories.map do |dir|
              File.join(dir, "**/*.mint")
            end

          if arguments.pattern.to_s.empty?
            files = Dir.glob(format_directories_patterns)
          else
            files = Dir.glob(arguments.pattern.to_s)
          end

          if files.empty?
            terminal.puts "Nothing to format!"
          else
            results =
              files.compact_map do |file|
                artifact =
                  Parser.parse(file)

                formatted =
                  Formatter.new(artifact, MintJson.parse_current.formatter_config).format

                if formatted != File.read(file)
                  File.write(file, formatted)
                  terminal.puts "Formatted: #{file}"
                  true
                end
              end

            terminal.puts "All files are formatted!" if results.empty?
          end
        rescue
          terminal.puts %(I was looking for a pattern that contains ".mint" files,)
          terminal.puts %(such as "source/**/*.mint". Got "#{arguments.pattern}" instead.)
        end
      end
    end
  end
end
