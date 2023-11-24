module Mint
  class Cli < Admiral::Command
    class Format < Admiral::Command
      include Command

      # The status of a file.
      enum Status
        NotFormatted
        Formatted
        Same
      end

      define_help description: "Formats .mint files."

      define_argument pattern : String,
        description: "The pattern which determines which files to format."

      define_flag check : Bool,
        description: "Checks that formatting code produces no changes.",
        default: false

      define_flag stdin : Bool,
        description: "Formats code from STDIN and writes it to STDOUT.",
        default: false

      def run
        if flags.stdin
          format_stdin
        else
          failed =
            execute "Formatting files" do
              result =
                format_files

              if result.empty?
                terminal.puts "Nothing to format!"
              else
                if result.all?(&.first.==(Status::Same))
                  terminal.puts "All files are formatted!"
                else
                  result.each do |(status, file)|
                    case status
                    when Status::NotFormatted
                      terminal.puts "Not formatted: #{file}"
                    when Status::Formatted
                      terminal.puts "Formatted: #{file}"
                    end
                  end
                end
              end

              result.any?(&.first.==(Status::NotFormatted))
            end

          exit(1) if flags.check && failed
        end
      end

      private def format_stdin
        input =
          STDIN.gets_to_end

        artifact =
          Parser.parse(input, "stdin.mint")

        formatted =
          Formatter.new(config).format(artifact)

        terminal.puts formatted
      rescue error : Error
        error error.to_terminal, terminal.position
      end

      private def format_files
        pattern =
          arguments.pattern.presence || json.try do |item|
            (item.source_directories | item.test_directories)
              .map(&->SourceFiles.glob_pattern(String))
          end

        Dir.glob(pattern || "").map do |file|
          artifact =
            Parser.parse(file)

          formatted =
            Formatter.new(config).format(artifact)

          next {Status::Same, file} if formatted == File.read(file)

          if flags.check
            {Status::NotFormatted, file}
          else
            File.write(file, formatted)
            {Status::Formatted, file}
          end
        end
      end

      # We try to honor the config of the current project but
      # allow for formatting without one using defaults.
      private def config
        json.try(&.formatter_config) || Formatter::Config.new
      end

      private def json
        MintJson.parse_current?
      end
    end
  end
end
