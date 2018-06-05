module Mint
  # Renders the main HTML file based on a mint.json file and an enviroment.
  class IndexHtml
    GLOBAL_STYLES =
      <<-CSS
      body {
        overflow-y: scroll;
        margin: 0;
      }

      * {
        box-sizing: border-box;
      }
      CSS

    getter json, env

    def self.render(env)
      new(env).to_s
    end

    def initialize(@env : Environment)
      @json = MintJson.parse_current
    end

    def to_s
      TreeTemplate.new(formatter: TreeTemplate::PrettyFormatter) do |t|
        t.doctype :html5

        t.html do
          t.head do
            t.meta(charset: json.application.meta["charset"]? || "utf-8")

            t.title json.application.title.to_s

            json.application.meta.each do |name, content|
              next if name == "charset"
              t.meta(name: name, content: content)
            end

            # Insert the extra head content
            t.unsafe json.application.head

            ICON_SIZES.each do |size|
              t.link(
                rel: "icon",
                type: "image/png",
                href: "/icon-#{size}x#{size}.png",
                sizes: "#{size}x#{size}")
            end

            [152, 167, 180].each do |size|
              t.link(
                rel: "apple-touch-icon-precomposed",
                href: "/icon-#{size}x#{size}.png")
            end

            # Insert global styles
            t.style(GLOBAL_STYLES)
          end

          t.body do
            # The main element to render the application into
            t.div(id: "root") { }

            # In development runtime comes separately and
            # the live reload script necessary.
            if env.development?
              t.script(src: "/runtime.js") { }
              t.script(src: "/live-reload.js") { }
            end

            t.script(src: "/index.js") { }
          end
        end
      end.render
    end
  end
end
