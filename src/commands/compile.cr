module Mint
  class Cli < Admiral::Command
    class Compile < Admiral::Command
      include Command

      define_help description: "Compiles the project into a single JavaScript"

      define_flag output : String,
        description: "The output file",
        default: "program.js",
        required: false,
        short: "o"

      def run
        execute "Compiling" do
          File.write(flags.output, compile)
        end
      end

      def compile
        runtime =
          Assets.read("runtime.js")

        sources =
          Dir.glob(SourceFiles.all)

        ast =
          Ast.new
            .merge(Core.ast)

        compiled = ""

        terminal.measure "  #{ARROW} Parsing #{sources.size} source files... " do
          sources.reduce(ast) do |memo, file|
            memo.merge Parser.parse(file)
            memo
          end
        end

        type_checker =
          TypeChecker.new(ast)

        terminal.measure "  #{ARROW} Type checking: " do
          type_checker.check
        end

        terminal.measure "  #{ARROW} Compiling: " do
          compiled = Compiler.compile_embed type_checker.artifacts, {optimize: true}
        end

        runtime + compiled
      end
    end
  end
end
