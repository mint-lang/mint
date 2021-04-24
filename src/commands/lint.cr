module Mint
  class Cli < Admiral::Command
    class Lint < Admiral::Command
      include Command

      define_help description: "Lints the project"

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
        json =
          MintJson.parse_current

        sources =
          Dir.glob(SourceFiles.all)

        ast =
          Ast.new
            .merge(Core.ast)

        runtime =
          Assets.read("runtime.js")

        errors = [] of String

        terminal.measure "  #{ARROW} Parsing #{sources.size} source files... " do
          sources.reduce(ast) do |memo, file|
            parsed = Parser.parse(file)

            if memo
              memo.merge parsed
            end
          rescue ex
            ex_handler errors, ex
          end
        end

        type_checker =
          TypeChecker.new(ast)

        terminal.measure "  #{ARROW} Type checking: " do
          type_checker.check
        rescue ex
          ex_handler errors, ex
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
