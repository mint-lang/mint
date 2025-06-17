module Mint
  class Cli < Admiral::Command
    class Lint < Admiral::Command
      include Command

      define_help description: "Lints the project for syntax and type errors."

      define_flag json : Bool,
        description: "Output errors in a JSON format.",
        default: false

      def run
        ast = Ast.new.merge(Core.ast)
        json = MintJson.current
        errors = [] of Error

        Dir.glob(SourceFiles.globs(json, include_tests: true))
          .reduce(ast) do |memo, file|
            begin
              memo.merge(Parser.parse(file))
            rescue error : Error
              errors << error
            end

            memo
          end

        begin
          TypeChecker.new(ast).tap(&.check)
        rescue error : Error
          errors << error
        end if errors.empty?

        if errors.empty?
          unless flags.json
            execute "Linting" do
              terminal.puts "No errors detected."
            end
          end
        else
          if flags.json
            json =
              errors.compact_map do |error|
                message = error.to_terminal.to_s.uncolorize

                if location = error.location
                  {
                    name:    error.name.to_s.upcase,
                    path:    location.path,
                    message: message,
                    start:   {
                      character: location.location[0].column,
                      line:      location.location[0].line,
                    },
                    end: {
                      character: location.location[1].column,
                      line:      location.location[1].line,
                    },
                  }
                else
                  {
                    name:    error.name.to_s.upcase,
                    message: message,
                  }
                end
              end.to_pretty_json

            terminal.puts json
          else
            if errors.empty?
              terminal.puts "No errors were detected!"
            else
              execute "Linting" do
                errors.each do |error|
                  terminal.print error.to_terminal
                end
              end
            end
          end

          exit(1)
        end
      end
    end
  end
end
