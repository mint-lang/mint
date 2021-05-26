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

      define_flag check : Bool,
        description: "Checks that formatting code produces no changes",
        default: false

      def run
        if flags.stdin
          format_stdin
        else
          succeeded = nil
          execute "Formatting files" do
            succeeded = format_files
          end
          exit(1) unless succeeded
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
              File.write(file, formatted) unless flags.check
              terminal.puts "Formatted: #{file}"
              all_formatted = false
            end
          end

          if all_formatted
            terminal.puts "All files are formatted!"
            true
          else
            false
          end
        end
      rescue
        terminal.puts %(I was looking for a pattern that contains ".mint" files,)
        terminal.puts %(such as "source/**/*.mint". Got "#{arguments.pattern}" instead.)
        false
      end
    end
  end
end
