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

      define_flag runtime : String,
        description: "Will use supplied runtime path instead of the default distribution",
        required: false

      def run
        execute "Compiling" do
          File.write(flags.output, compile(flags.minify, flags.runtime))
        end
      end

      def compile(optimize, runtime_path)
        json =
          MintJson.parse_current

        runtime =
          if runtime_path
            Cli.runtime_file_not_found(runtime_path) unless File.exists?(runtime_path)
            File.read(runtime_path)
          else
            Assets.read("runtime.js")
          end

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
          TypeChecker.new(ast, web_components: json.web_components.keys)

        terminal.measure "  #{ARROW} Type checking..." do
          type_checker.check
        end

        compiled = nil

        terminal.measure "  #{ARROW} Compiling..." do
          compiled = Compiler.compile_embed type_checker.artifacts, {
            css_prefix:     json.application.css_prefix,
            web_components: json.web_components,
            relative:       false,
            optimize:       optimize,
            build:          true,
          }
        end

        runtime + compiled.to_s
      end
    end
  end
end
