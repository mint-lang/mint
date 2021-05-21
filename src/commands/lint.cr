module Mint
  class Cli < Admiral::Command
    class Lint < Admiral::Command
      include Command

      define_help description: "Lints the project for syntax and type errors"

      define_flag json : Bool,
        description: "Output errors in a JSON format",
        default: false,
        required: false

      def run
        if flags.json
          colorize_enabled = Colorize.enabled?
          begin
            Colorize.enabled = false
            lint
          ensure
            Colorize.enabled = colorize_enabled
          end
        else
          execute "Linting" do
            lint
          end
        end
      end

      protected def parse(ast, errors) : Nil
        sources =
          Dir.glob(SourceFiles.all)

        sources.reduce(ast) do |memo, file|
          begin
            parsed =
              Parser.parse(file)

            memo.merge(parsed)
          rescue ex
            errors << ex
          end
          memo
        end
      rescue ex
        errors << ex
      end

      protected def type_check(ast, errors) : Nil
        type_checker =
          TypeChecker.new(ast)

        loop do
          type_checker.check
        rescue ex
          errors << ex
        else
          break
        end
      rescue ex
        errors << ex
      end

      def lint
        errors = [] of Exception

        ast =
          Ast.new
            .merge(Core.ast)

        parse(ast, errors)
        type_check(ast, errors) if errors.empty?

        if flags.json
          terminal.puts errors.compact_map(&.message.presence).to_json
        else
          if errors.empty?
            terminal.puts "No errors were detected!"
          else
            errors.each do |error|
              terminal.puts error
            end
            terminal.divider
            error nil, terminal.position
          end
        end

        exit(1) unless errors.empty?
      end
    end
  end
end
