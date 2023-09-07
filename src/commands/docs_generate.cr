module Mint
  class Cli < Admiral::Command
    class DocsGenerate < Admiral::Command
      include Command

      define_help description: "Starts the documentation server"

      define_flag output : String,
        description: "The output filename",
        default: "docs.json",
        required: false,
        short: "o"

      def run
        execute "Generating Documentation" do
          current =
            MintJson.parse_current

          ast =
            Ast.new

          current.source_files.each do |file|
            ast.merge(Parser.parse(File.read(file), file))
          end

          ast.normalize

          # json =
          #   DocumentationGeneratorJson.new.generate(current, ast)

          # File.write(flags.output, json)

          docgenHtml = DocumentationGeneratorHtml.new("mint-lang", "mint-ui", "7.0.0")
          docgenHtml.generate(current, ast)
          docgenHtml.readme(current)
        end
      end
    end
  end
end
