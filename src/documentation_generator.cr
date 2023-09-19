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
    @git_source : GitSource
    @core_types : Hash(String, String)
    @types : Hash(String, String)
    @pages = Hash(String, Array(String)).new
    @page_children = Hash(Array(String), Array(String)).new
    @category : String = ""
    @page : String = ""

    def initialize(@mint_json : MintJson, @ast : Ast, @output_dir : String, @base : String, git_url : String, git_url_pattern : String, git_ref : String)
      @git_source = GitSource.new(git_url, git_url_pattern, git_ref)
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
      write_readme()
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

      Dir.mkdir_p("#{@output_dir}")
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
    end

    def read_markdown(path : String)
      content =
        begin
          File.read("#{@mint_json.root}/#{path}")
        rescue
          "# Could not find a #{path} file"
        end

      Markd.to_html(content)
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

    def url_base
      if @base == ""
        "/"
      else
        ""
      end
    end

    def readme_url
      "#{url_base}index.html"
    end

    def page_url(category : String, page : String)
      "#{url_base}#{category}/#{page}"
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

    def git_url(node)
      @git_source.get_node_url(node)
    end
  end
end
