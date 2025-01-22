module Mint
  module ErrorMessage
    def self.render(error : Error, *, live_reload = true) : Hash(String, Proc(String))
      files = {} of String => Proc(String)

      files["/live-reload.js"] =
        -> { Assets.read("live-reload.js") } if live_reload

      files["/index.html"] =
        -> do
          HtmlBuilder.build(optimize: true) do
            html do
              head do
                meta charset: "utf-8"
                meta content: "width=device-width, initial-scale=1", name: "viewport"

                title { text "#{error.name.to_s.upcase} | Mint Error" }

                link rel: "stylesheet", href: "/style.css"
                script src: "/live-reload.js" if live_reload
              end

              body do
                pre { code { text error.to_terminal.to_s.uncolorize } }
              end
            end
          end
        end

      Assets.files.each do |file|
        next unless file.path.starts_with?("/error_message/")
        files[file.path.lchop("/error_message")] = -> { Assets.read(file.path) }
      end

      files
    end
  end
end
