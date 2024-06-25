module Mint
  class DocumentationGeneratorJson
    include Helpers

    @formatter = Formatter.new

    def generate(asts : Hash(MintJson, Ast))
      JSON.build do |json|
        json.object do
          json.field "packages" do
            json.array do
              asts.each do |package, ast|
                generate package, ast, json
              end
            end
          end
        end
      end
    end

    def generate(mint_json, ast : Ast)
      JSON.build do |json|
        generate mint_json, ast, json
      end
    end

    def generate(node : Ast::Node, json)
    end

    def generate(mint_json, ast : Ast, json)
      json.object do
        json.field "name", mint_json.name

        json.field "dependencies" do
          json.array do
            mint_json.dependencies.each do |dependency|
              json.object do
                json.field "name", dependency.name
                json.field "repository", dependency.repository
                json.field "constraint", dependency.constraint.to_s
              end
            end
          end
        end

        json.field "components" do
          generate ast.components.sort_by(&.name.value), json
        end

        json.field "stores" do
          generate ast.stores.sort_by(&.name.value), json
        end

        json.field "modules" do
          generate ast.unified_modules.sort_by(&.name.value), json
        end

        json.field "providers" do
          generate ast.providers.sort_by(&.name.value), json
        end

        json.field "records" do
          generate ast.type_definitions.sort_by(&.name.value), json
        end
      end
    end

    def stringify(node : Ast::Node)
      ""
    end

    def stringify(nodes : Array(Ast::Node))
      nodes.join(", ") { |node| stringify node }
    end

    def generate(nodes : Array(Ast::Node), json : JSON::Builder)
      json.array { nodes.each { |node| generate node, json } }
    end

    def source(node)
      @formatter.source(node)
    end
  end

  class DocumentationGeneratorHtml
    class Page
      getter category, subcategory, parent, name

      def initialize(@category : String, @subcategory : String, @parent : String, @name : String)
      end
    end

    @formatter = Formatter.new
    @core_types : Hash(String, String)
    @types : Hash(String, String)
    @pages = Hash(String, Array(String)).new
    @page_children = Hash(Array(String), Array(String)).new
    @category : String = ""
    @page : String = ""
    @git_root : String = ""

    def initialize(@mint_json : MintJson, @ast : Ast, @output_dir : String, @base : String, @git_ref : String)
      @git_root = parse_git_root
      @pages = {
        "components" => @ast.components.map(&.name.value).sort!,
        "modules"    => @ast.modules.map(&.name.value).sort!,
        "providers"  => @ast.providers.map(&.name.value).sort!,
        "stores"     => @ast.stores.map(&.name.value).sort!,
        "types"      => @ast.type_definitions.map(&.name.value).sort!,
      }
      @core_types = build_types_lookup(Core.ast)
      @types = build_types_lookup(ast)
    end

    def build_types_lookup(a : Ast)
      # order matters here when things get dedeuped
      all = a.components.map { |i| [i.name.value, "components"] } |
            a.modules.map { |i| [i.name.value, "modules"] } |
            a.providers.map { |i| [i.name.value, "providers"] } |
            a.stores.map { |i| [i.name.value, "stores"] } |
            a.type_definitions.map { |i| [i.name.value, "types"] }

      all.to_h
    end

    def generate
      Dir.mkdir_p("#{@output_dir}")
      Dir.mkdir_p("#{@output_dir}/assets")
      write_assets()
      write_readme()
      write_pages()
    end

    def write_assets
      Assets.files
        .select(&.path.includes?("/docs-html/"))
        .each { |file|
          content = file.gets_to_end
          basename = Path[file.path].basename
          path = Path[@output_dir, "assets", basename].to_s
          File.write(path, content)
        }
    end

    def write_pages
      @ast.components.each { |node| write_page("components", node) }
      @ast.type_definitions.each { |node| write_page("types", node) }
      @ast.modules.each { |node| write_page("modules", node) }
      @ast.providers.each { |node| write_page("providers", node) }
      @ast.stores.each { |node| write_page("stores", node) }
    end

    def write_page(category : String, node : Ast::Node)
      @category = category
      @page = node.name.value

      # ameba:disable Lint/UselessAssign
      content = generate(node)

      html = render("#{__DIR__}/documentation_generator/html/page.ecr")

      Dir.mkdir_p("#{@output_dir}/#{@category}")
      File.write("#{@output_dir}/#{@category}/#{@page}.html", html)
    end

    def write_readme
      @page = "README"

      # ameba:disable Lint/UselessAssign
      content = read_markdown("README.md")

      html = render("#{__DIR__}/documentation_generator/html/page.ecr")

      File.write("#{@output_dir}/index.html", html)
    end

    def nav_item(node : Ast::Node, category : String)
      render("#{__DIR__}/documentation_generator/html/nav_item.ecr")
    end

    def generate(node)
    end

    def stringify(children : Array(Page))
      children.map(&.name).join("|")
    end

    def stringify(nodes : Array(Ast::Node))
      nodes.join(", ") { |node| stringify node }
    end

    def stringify(node)
      ""
    end

    def read_markdown(path : String)
      content =
        begin
          File.read("#{@mint_json.root}/#{path}")
        rescue
          "# Could not find a #{path} file"
        end

      markdown = Markd.to_html(content)

      highlight_markdown(markdown)
    end

    def highlight_markdown(markdown : String)
      markdown.gsub(/<code class="language-mint">((.|\n)*)<\/code>/) {
        html = HTML.unescape($1)

        tokenized = SemanticTokenizer.highlight(html, "example.mint", true)

        "<code class=\"language-mint\">#{tokenized}</code>"
      }
    end

    def source(node : Ast::Node) : String
      @formatter.source(node)
    end

    def source(node : Ast::Node | Nil) : String
      ""
    end

    def search(node)
      "#{stringify(node)}|#{stringify(children(node))}".downcase
    end

    def children(category : String, subcategory : String, page : Ast::Node, children : Array(Ast::Node)) : Array(Page)
      children
        .sort_by(&.name.value)
        .map { |node| Page.new(category, subcategory, page.name.value, node.name.value) }
    end

    def children(node)
      [] of Page
    end

    def is_page_active(category : String, node : Ast::Node)
      category == @category && stringify(node) == @page
    end

    def is_git_repo
      `git rev-parse --is-inside-work-tree`.strip == "true"
    end

    def parse_git_root : String
      if is_git_repo
        `git rev-parse --show-toplevel`.strip
      else
        ""
      end
    end

    def base_url
      if @base == ""
        "/"
      else
        ""
      end
    end

    def readme_url
      "#{base_url}index.html"
    end

    def page_url(category : String, page : String)
      "#{base_url}#{category}/#{page}.html"
    end

    def anchor_url(node)
      "#{page_url(@category, @page)}##{stringify(node)}"
    end

    def anchor_url(child : Page)
      "#{page_url(child.category, child.parent)}##{child.name}"
    end

    def type_url(type : String)
      core = @core_types.fetch(type, "")
      own = @types.fetch(type, "")

      if own != ""
        page_url(own, type)
      elsif core != ""
        "https://mint-lang.com/api/#{core}/#{type}"
      else
        ""
      end
    end

    def source_url(node)
      url = @mint_json.source_url
      user, repo = SourceUrl.parse_user_and_repo(url)
      path = node.location.filename.sub("#{@git_root}/", "")
      line = node.location.start[0]
      s_url =
        if url.includes?("github")
          "https://github.com/#{user}/#{repo}/blob/#{@git_ref}/#{path}#L#{line}"
        elsif url.includes?("gitlab")
          "https://gitlab.com/#{user}/#{repo}/blob/#{@git_ref}/#{path}#L#{line}"
        elsif url.includes?("bitbucket")
          "https://bitbucket.org/#{user}/#{repo}/src/#{@git_ref}/#{path}#cl-#{line}"
        else
          ""
        end

      if s_url.empty?
        ""
      else
        "<a class=\"github-source-link\" href=\"#{s_url}\"></a>"
      end
    end
  end
end
