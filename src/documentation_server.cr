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
          when String
            @error = result
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
        case env.params.url["name"]
        when "doc.css"
          File.read("../mint/public/doc.css")
        else
          entity env.params.url["name"]
        end
      end
    end

    def generate(nodes : Array(Ast::Node), t)
      nodes.each do |node|
        generate node, t
      end
    end

    def generate(a, t)
    end

    def generate(a)
      page do |t|
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
        t.div "Stores"

        @ast.stores.sort_by(&.name).each do |item|
          t.a href: "/#{item.name}" do
            t.div "S", class: "badge badge--store"
            t.span item.name
          end
        end
      end

      if @ast.components.any?
        t.div "Components"

        @ast.components.sort_by(&.name).each do |item|
          t.a href: "/#{item.name}" do
            t.div "C", class: "badge badge--component"
            t.span item.name
          end
        end
      end

      if @ast.modules.any?
        t.div "Modules"

        @ast.modules.sort_by(&.name).each do |item|
          t.a href: "/#{item.name}" do
            t.div "M", class: "badge badge--module"
            t.span item.name
          end
        end
      end
    end

    macro page
      TreeTemplate.new do |t|
        t.html do
          t.head do
            t.link href: "/doc.css", rel: "stylesheet"
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

    def subtitle(text, t)
      t.div text, class: "subtitle"
    end

    def title(text, t)
      t.div text, class: "title"
    end

    def index
      page do |t|
        t.div "index"
      end
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
