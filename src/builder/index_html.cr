class IndexHtml
  getter json, env

  def initialize(@env : Environment)
    @json = MintJson.parse_current
  end

  def self.render(env)
    new(env).to_s
  end

  def to_s
    TreeTemplate.new(formatter: TreeTemplate::PrettyFormatter) do |t|
      t.doctype :html5
      t.html do
        t.head do
          t.title(json.application.title.to_s)

          json.application.meta.each do |name, content|
            if name == "charset"
              t.meta(charset: "utf-8")
            else
              t.meta(name: name, conent: content)
            end
          end

          json.application.external_stylesheets.each do |href|
            t.link(rel: "stylesheet", href: href)
          end

          Builder::SIZES.each do |size|
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

          t.style(GLOBAL_STYLES)
        end

        t.body do
          t.div(id: "root") { }

          if env.development?
            t.script(src: "/runtime.js") { }
            t.script(src: "/live-reload.js") { }
          end

          t.script(src: "/index.js") { }
          t.script("Mint.render()", type: "text/javascript")
        end
      end
    end.render
  end
end
