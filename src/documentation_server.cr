module Mint
  class DocumentationServer
    @formatter = Formatter.new(Ast.new)
    @error : String | Nil = nil
    @ast : Ast = Ast.new

    def self.start
      new
    end

    def initialize
      @watcher =
        AstWatcher.new(->{ SourceFiles.current }) do |result|
          case result
          when Ast
            @ast = result
            @error = nil
          when Error
            raise result
          end
        end

      spawn do
        @watcher.watch do |result|
          case result
          when Ast
            @ast = result
            @error = nil
          when Error
            @error = result.to_html
            @ast = Ast.new
          end
        end
      end

      setup_kemal

      Server.run(name: "Documentation", port: 3002)
    end

    def setup_kemal
      get "/" do
        index
      end

      get "/:name" do |env|
        if @error
          @error.to_s
        else
          case env.params.url["name"]
          when "doc.css"
            Assets.read("doc.css")
          else
            entity env.params.url["name"]
          end
        end
      end
    end

    def generate(nodes : Array(Ast::Node), t)
      nodes.each do |node|
        generate node, t
      end
    end

    def generate(a, t)
      t.span a.to_s
    end

    def generate(a)
      page "Documentation" do |t|
        t.div "Not found"
      end
    end

    def format(node, t)
      t.div class: "source" do
        t.label for: node.hash.to_s do
          t.text "Show source"
        end
        t.input type: "checkbox", id: node.hash.to_s
        t.pre @formatter.format(node)
      end
    end

    def entity(name)
      item =
        @ast.modules.find(&.name.==(name)) ||
          @ast.components.find(&.name.==(name)) ||
          @ast.stores.find(&.name.==(name))

      generate item
    end

    def sidebar(t)
      if @ast.stores.any?
        sidebar_header "Stores", t

        @ast.stores.sort_by(&.name).each do |item|
          t.a href: "/#{item.name}" do
            t.div "S", class: "badge badge--store"
            t.span item.name
          end
        end
      end

      if @ast.components.any?
        sidebar_header "Components", t

        @ast.components.sort_by(&.name).each do |item|
          t.a href: "/#{item.name}" do
            t.div "C", class: "badge badge--component"
            t.span item.name
          end
        end
      end

      if @ast.modules.any?
        sidebar_header "Modules", t

        @ast.modules.sort_by(&.name).each do |item|
          t.a href: "/#{item.name}" do
            t.div "M", class: "badge badge--module"
            t.span item.name
          end
        end
      end
    end

    macro page(name)
      TreeTemplate.new do |t|
        t.html do
          t.head do
            t.meta charset: "utf-8"
            t.link href: "/doc.css", rel: "stylesheet"
            t.title {{name}}
          end

          t.body do
            t.aside do
              sidebar t
            end

            t.section do
              {{yield t}}
            end
          end
        end
      end.render
    end

    def sidebar_header(text, t)
      t.div text, class: "sidebar-header"
    end

    def subtitle(text, t)
      t.div text, class: "subtitle"
    end

    def title(text, hint, t)
      t.div class: "title" do
        t.span hint
        t.strong text
      end
    end

    def index
      page "Documentation" do |t|
        t.div "index"
      end
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
