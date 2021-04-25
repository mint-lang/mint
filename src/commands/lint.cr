module Mint
  class Cli < Admiral::Command
    class Lint < Admiral::Command
      include Command

      define_help description: "Lints the project for syntax and type errors."

      define_flag json : Bool,
        description: "Output errors to a JSON file",
        default: false,
        required: false

      define_flag output : String,
        description: "The output filename",
        default: "lint.json",
        required: false,
        short: "o"

      def run
        execute "Linting" do
          lint
        end
      end

      def lint
        errors = [] of String
        sources = [] of String

        begin
          sources =
            Dir.glob(SourceFiles.all)
        rescue ex
          ex_handler errors, ex
        end

        ast =
          Ast.new
            .merge(Core.ast)

        sources.reduce(ast) do |memo, file|
          parsed = Parser.parse(file)

          if memo
            memo.merge parsed
          end
        rescue ex
          ex_handler errors, ex
        end

        if errors.size == 0
          type_checker =
            TypeChecker.new(ast)

          done = false

          while !done
            begin
              type_checker.check
            rescue ex
              ex_handler errors, ex
            else
              done = true
            end
          end
        end

        if flags.json
          File.write(flags.output, errors)
        end

        if errors.size > 0
          exit 1
        end
      end

      def ex_handler(errors, ex)
        if ex.message.is_a?(String)
          errors << ex.message.as(String).to_json
        end

        puts ex
      end
    end
  end
end
