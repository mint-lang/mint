module Mint
  class Cli < Admiral::Command
    class Lint < Admiral::Command
      include Command

      define_help description: "Lints the project for syntax and type errors."

      define_flag json : Bool,
        description: "Output errors in a JSON format.",
        default: false

      def run
        succeeded =
          if flags.json
            lint
          else
            execute "Linting" { lint }
          end

        exit(1) unless succeeded
      end

      protected def parse(ast, errors) : Nil
        sources =
          Dir.glob(SourceFiles.all)

        sources.reduce(ast) do |memo, file|
          begin
            memo.merge(Parser.parse(file))
          rescue error : Error
            errors << error
          end

          memo
        end
      end

      protected def type_check(ast, errors) : Nil
        TypeChecker.new(ast).tap(&.check)
      rescue error : Error
        errors << error
      end

      def lint
        errors =
          [] of Error

        ast =
          Ast.new.merge(Core.ast)

        parse(ast, errors)
        type_check(ast, errors) if errors.empty?

        if flags.json
          terminal.puts errors.compact_map(&.to_terminal.to_s.uncolorize).to_json
        else
          if errors.empty?
            terminal.puts "No errors were detected!"
          else
            errors.each do |error|
              terminal.print error.to_terminal
            end
          end
        end

        errors.empty?
      end
    end
  end
end
