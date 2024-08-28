module Mint
  class Cli < Admiral::Command
    class Lint < Admiral::Command
      include Command

      define_help description: "Lints the project for syntax and type errors."

      define_flag json : Bool,
        description: "Output errors in a JSON format.",
        default: false

      def run
        ast =
          Ast.new.merge(Core.ast)

        errors =
          [] of Error

        Dir.glob(SourceFiles.all).reduce(ast) do |memo, file|
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
            terminal.puts errors.compact_map(&.to_terminal.to_s.uncolorize).to_json
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
