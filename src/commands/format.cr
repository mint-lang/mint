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
          all_formatted = true

          execute "Formatting files" do
            all_formatted = format_files
          end

          exit(1) if flags.check && !all_formatted
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
      rescue error : Error
        error(error.to_terminal, terminal.position)
      end

      private def format_files
        current =
          MintJson.parse_current?

        files =
          if pattern_argument = arguments.pattern.presence
            Dir.glob(pattern_argument)
          elsif current
            format_directories =
              current.source_directories | current.test_directories

            format_directories_patterns =
              format_directories.map do |dir|
                SourceFiles.glob_pattern(dir)
              end
            Dir.glob(format_directories_patterns)
          end

        if files.try(&.empty?)
          terminal.puts "Nothing to format!"
          true
        else
          all_formatted = true

          files.not_nil!.each do |file|
            artifact =
              Parser.parse(file)

            config =
              if current
                MintJson.parse_current.formatter_config
              else
                Formatter::Config.new
              end

            formatted =
              Formatter.new(config).format(artifact)

            unless formatted == File.read(file)
              if flags.check
                terminal.puts "Not formatted: #{file}"
              else
                File.write(file, formatted)
                terminal.puts "Formatted: #{file}"
              end
              all_formatted = false
            end
          end

          terminal.puts "All files are formatted!" if all_formatted
          all_formatted
        end
      rescue error : Error
        raise error
      end
    end
  end
end
