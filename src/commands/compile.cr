module Mint
  class Cli < Admiral::Command
    class Compile < Admiral::Command
      include Command

      define_help description: "Compiles the project into a single JavaScript file"

      define_flag output : String,
        description: "The output file",
        default: "program.js",
        required: false,
        short: "o"

      define_flag minify : Bool,
        description: "If specified the resulting JavaScript code will be minified",
        default: true,
        short: "m"

      def run
        execute "Compiling" do
          File.write(flags.output, compile(flags.minify))
        end
      end

      def compile(optimize)
        json =
          MintJson.parse_current

        runtime =
          Assets.read("runtime.js")

        sources =
          Dir.glob(SourceFiles.all)

        ast =
          Ast.new
            .merge(Core.ast)

        terminal.measure "  #{ARROW} Parsing #{sources.size} source files..." do
          sources.reduce(ast) do |memo, file|
            memo.merge Parser.parse(file)
          end
        end

        type_checker =
          TypeChecker.new(ast)

        terminal.measure "  #{ARROW} Type checking..." do
          type_checker.check
        end

        compiled = nil

        terminal.measure "  #{ARROW} Compiling..." do
          compiled = Compiler.compile_embed type_checker.artifacts, {
            css_prefix: json.application.css_prefix,
            relative:   false,
            optimize:   optimize,
            build:      true,
          }
        end

        runtime + compiled.to_s
      end
    end
  end
end
