module Mint
  # Renders the main HTML file based on a mint.json file and an enviroment.
  class IndexHtml
    getter json, env

    def self.render(env, relative = false, no_service_worker = false)
      new(env, relative, no_service_worker).to_s
    end

    def initialize(@env : Environment, @relative : Bool, @no_service_worker : Bool)
      @json = MintJson.parse_current
    end

    def path_for(url)
      if @relative
        url
      else
        "/#{url}"
      end
    end

    def to_s
      TreeTemplate.new(formatter: TreeTemplate::PrettyFormatter) do |t|
        t.doctype :html5

        t.html do
          t.head do
            t.meta(charset: json.application.meta["charset"]? || "utf-8")

            t.title json.application.title.to_s

            t.link(rel: "manifest", href: "/manifest.json")

            json.application.meta.each do |name, content|
              next if name == "charset"
              t.meta(name: name, content: content)
            end

            t.meta(name: "theme-color", content: json.application.theme)

            # Insert the extra head content
            t.unsafe json.application.head

            ICON_SIZES.each do |size|
              t.link(
                rel: "icon",
                type: "image/png",
                href: path_for("icon-#{size}x#{size}.png"),
                sizes: "#{size}x#{size}")
            end

            [152, 167, 180].each do |size|
              t.link(
                rel: "apple-touch-icon-precomposed",
                href: path_for("icon-#{size}x#{size}.png"))
            end
          end

          t.body do
            # In development runtime comes separately and
            # the live reload script necessary.
            if env.development?
              t.script(src: path_for("runtime.js")) { }
              t.script(src: path_for("live-reload.js")) { }
            else
              if !@no_service_worker
                t.script(type: "text/javascript") do
                  t.unsafe <<-JS
                  if ('serviceWorker' in navigator) {
                    window.addEventListener('load', function() {
                      navigator.serviceWorker.register('/service-worker.js')
                    })
                  }
                  JS
                end
              end
            end

            t.script(src: path_for("index.js")) { }

            t.noscript do
              t.text "This application requires JavaScript."
            end
          end
        end
      end.render
    end
  end
end
