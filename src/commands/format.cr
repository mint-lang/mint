module Mint
  class Cli < Admiral::Command
    class Format < Admiral::Command
      include Command

      define_help description: "Formats source files"

      define_argument pattern,
        description: "The pattern which determines which files to format"

      define_flag stdin : Bool,
        description: "Formats Mint code from STDIN",
        default: false

      def run
        if flags.stdin
          format_stdin
        else
          format_files
        end
      end

      private def format_stdin
        input =
          STDIN.gets_to_end

        artifact =
          Parser.parse(input, "stdin.mint")

        formatted =
          Formatter.new(MintJson.parse_current.formatter_config).format(artifact)

        terminal.puts formatted
      end

      private def format_files
        execute "Formatting files" do
          current =
            MintJson.parse_current

          format_directories =
            current.source_directories | current.test_directories

          format_directories_patterns =
            format_directories.map do |dir|
              SourceFiles.glob_pattern(dir)
            end

          if arguments.pattern.to_s.empty?
            files = Dir.glob(format_directories_patterns)
          else
            files = Dir.glob(arguments.pattern.to_s)
          end

          if files.empty?
            terminal.puts "Nothing to format!"
          else
            all_formatted = true

            files.each do |file|
              artifact =
                Parser.parse(file)

              formatted =
                Formatter.new(MintJson.parse_current.formatter_config).format(artifact)

              unless formatted == File.read(file)
                File.write(file, formatted)
                terminal.puts "Formatted: #{file}"
                all_formatted = false
              end
            end

            terminal.puts "All files are formatted!" if all_formatted
          end
        rescue
          terminal.puts %(I was looking for a pattern that contains ".mint" files,)
          terminal.puts %(such as "source/**/*.mint". Got "#{arguments.pattern}" instead.)
        end
      end
    end
  end
end
