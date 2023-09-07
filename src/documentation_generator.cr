module Mint
  class DocumentationGeneratorJson
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
          generate ast.records.sort_by(&.name.value), json
        end

        json.field "enums" do
          generate ast.enums.sort_by(&.name.value), json
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
    @formatter = Formatter.new
    @mint_json = MintJson.new(%({"name": "core"}), "core", "mint.json")
    @ast = Ast.new
    @core_entity_categories = Hash(String, String).new
    @entity_categories = Hash(String, String).new
    @entities = Hash(String, Array(String)).new
    @category : String = ""
    @active : String = "README"

    def initialize(@user : String, @repo : String, @version : String)
      @core_entity_categories = build_entity_categories(Core.ast)
    end

    def build_entity_categories(ast : Ast)
      components = ast.components.map { |n| [n.name.value, "component"] }
      enums = ast.enums.map { |n| [n.name.value, "enum"] }
      modules = ast.modules.map { |n| [n.name.value, "module"] }
      providers = ast.providers.map { |n| [n.name.value, "provider"] }
      records = ast.records.map { |n| [n.name.value, "record"] }
      stores = ast.components.map { |n| [n.name.value, "component"] }
      all = components | enums | modules | providers | records | stores
      all.to_h
    end

    def generate(node : Ast::Node, json)
    end

    def generate(node : Ast::Node)
    end

    def generate(mint_json : MintJson, ast : Ast)
      @mint_json = mint_json
      @ast = ast
      @entities = {
        "component" => ast.components.map(&.name.value).sort,
        "enum"      => ast.enums.map(&.name.value).sort,
        "module"    => ast.modules.map(&.name.value).sort,
        "provider"  => ast.providers.map(&.name.value).sort,
        "record"    => ast.records.map(&.name.value).sort,
        "store"     => ast.stores.map(&.name.value).sort,
      }

      @entity_categories = build_entity_categories(ast)

      ast.components.each { |node| write_html("component", node) }

      ast.enums.each { |node| write_html("enum", node) }

      ast.modules.each { |node| write_html("module", node) }

      ast.providers.each { |node| write_html("provider", node) }

      ast.records.each { |node| write_html("record", node) }

      ast.stores.each { |node| write_html("store", node) }
    end

    def write_html(category : String, node : Ast::Node)
      @category = category
      @active = node.name.value
      content = generate(node)
      html = render("#{__DIR__}/documentation_generator/html/page.ecr")
      Dir.mkdir_p("docs/#{category}")
      File.write("docs/#{category}/#{node.name.value}.html", html)
    end

    def readme(mint_json : MintJson)
      @active = "README"
      readme = File.read("#{mint_json.root}/README.md")
      content = Markd.to_html(readme)
      html = render("#{__DIR__}/documentation_generator/html/page.ecr")
      File.write("docs/README.html", html)
    end

    def stringify(node : Ast::Node)
      ""
    end

    def stringify_html(node : Ast::Node)
      ""
    end

    def stringify(nodes : Array(Ast::Node))
      nodes.join(", ") { |node| stringify node }
    end

    def source(node)
      @formatter.source(node)
    end
    
    def type_url(entity : String)
      core_category = @core_entity_categories.fetch(entity, "")
      category = @entity_categories.fetch(entity, "")

      if category != ""
        "https://mint-lang.com/api/#{core_category}/#{@active}##{entity}"
      elsif core_category != ""
        "#{category}/#{@active}##{entity}"
      else
        ""
      end
    end

    def anchor_url(entity : String)
      "#{@category}/#{@active}##{entity}"
    end

    def github_source_url(node : Ast::Node)
      path = node.location.filename.sub(@mint_json.root, "")

      "https://github.com/#{@user}/#{@repo}/blob/#{@version}#{path}#L#{node.location.start[0]}"
    end
  end
end
