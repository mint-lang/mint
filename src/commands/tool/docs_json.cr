module Mint
  class Cli < Admiral::Command
    class DocsJson < Admiral::Command
      include Command

      define_help description: "Generates API Documentation in JSON format."

      define_flag include_core : Bool,
        description: "If specified, documentation will be generated for the standard library as well.",
        default: false

      define_flag include_packages : Bool,
        description: "If specified, documentation will be generated for used packages as well.",
        default: false

      define_flag pretty : Bool,
        description: "If specified, the JSON will be pretty printed.",
        default: false

      define_argument output : String,
        description: "The output file to save it to.",
        default: "docs.json",
        required: true

      def run
        execute "Generating JSON documentation" do
          json =
            MintJson.current

          jsons =
            if flags.include_packages
              SourceFiles.packages(json, include_self: true)
            else
              [json]
            end

          asts =
            Dir.glob(SourceFiles.globs(jsons)).map do |file|
              Ast.new.tap do |ast|
                ast.merge(Parser.parse(File.read(file), file))
              end
            end

          asts << Core.ast if flags.include_core

          ast =
            asts
              .reduce(Ast.new) { |memo, item| memo.merge(item) }
              .tap(&.normalize)

          entities =
            DocumentationGenerator.resolve(ast)

          contents =
            if flags.pretty
              entities.to_pretty_json
            else
              entities.to_json
            end

          File.write_p(arguments.output, contents)
          terminal.puts "#{COG} Generated documentation."
        end
      end
    end
  end
end
