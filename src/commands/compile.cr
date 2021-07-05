module Mint
  class Cli < Admiral::Command
    class Compile < Admiral::Command
      include Command

      define_help description: "Compiles the project into a single JavaScript file"

      define_flag output : String,
        description: "The output file",
        default: "program.js",
        short: "o"

      define_flag minify : Bool,
        description: "If specified the resulting JavaScript code will be minified",
        default: true,
        short: "m"

      define_flag source_map : Bool,
        description: "If specified generate source mappings for debugging",
        default: false

      def run
        execute "Compiling" do
          result =
            compile(flags.minify, flags.source_map)

          File.write(flags.output, result[:code])

          result[:source_map].try do |map|
            File.write("#{flags.output}.map", map)
          end
        end
      end

      def compile(optimize, generate_source_map : Bool)
        json =
          MintJson.parse_current

        runtime =
          Assets.read("runtime.js").as(Codegen::Node)

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

        result =
          Codegen.build(Codegen.join([runtime, compiled].compact), generate_source_map)

        source_map : String? = nil

        result[:source_map].try do |map|
          terminal.measure "  #{ARROW} Generating source map: " do
            source_map = map.build_json
          end
        end

        {code: result[:code], source_map: source_map}
      end
    end
  end
end
