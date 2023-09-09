module Mint
  class Cli < Admiral::Command
    class DocsGenerate < Admiral::Command
      include Command

      define_help description: "Generates static html and json documentation"

      define_flag base : String,
        description: "Sets the <base> url in the generated html files",
        default: "",
        short: "b"

      define_flag git_ref : String,
        description: "The git reference",
        required: false

      define_flag git_url : String,
        description: "The git repository source url",
        required: false
        
      define_flag git_url_pattern : String,
        description: "The git repository source url pattern",
        required: false

      define_flag output_dir : String,
        description: "The output directory",
        default: "docs",
        short: "d"

      define_flag json : String,
        description: "The json output filename",
        default: "docs.json",
        short: "j"

      def run
        execute "Generating Documentation" do
          ast =
            Ast.new

          mint_json =
            MintJson.parse_current

          mint_json.source_files.each do |file|
            ast.merge(Parser.parse(File.read(file), file))
          end

          ast.normalize

          html(ast, mint_json)
          
          json(ast, mint_json)
        end
      end

      def html(ast : Ast, mint_json : MintJson)
        git_source = DocumentationGeneratorHtml::GitSource.new(
          flags.git_url,
          flags.git_url_pattern,
          flags.git_ref
        )

        DocumentationGeneratorHtml
          .new(
            mint_json,
            ast,
            git_source,
            flags.output_dir,
            flags.base,
          ).generate
      end

      def json(ast : Ast, mint_json : MintJson)
        json =
            DocumentationGeneratorJson.new.generate(mint_json, ast)

        json_file = "#{flags.output_dir}/#{flags.json}"

        Dir.mkdir_p(Path.new(json_file).dirname)
        File.write(json_file, json)
      end
    end
  end
end
