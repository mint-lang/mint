module Mint
  class Cli < Admiral::Command
    class Docs < Admiral::Command
      include Command

      define_help description: "Generates API Documentation"

      define_flag output : String,
        description: "The output filename",
        default: "docs.json",
        required: false,
        short: "o"

      def run
        execute "Documentation Generator" do
          puts "#{COG} Generating documentation..."

          current =
            MintJson.parse_current

          generator =
            DocumentationGenerator2.new

          ast =
            Ast.new.tap do |item|
              current.source_files.each do |file|
                item.merge(Parser.parse(File.read(file), file))
              end
            end.normalize

          json =
            generator.resolve(ast).to_json

          File.write(flags.output, json)
        end
      end
    end
  end
end
