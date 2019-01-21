module Mint
  class Builder
    def initialize(relative, skip_service_worker)
      json = MintJson.parse_current

      terminal.measure "#{COG} Ensuring dependencies... " do
        json.check_dependencies!
      end

      terminal.measure "#{COG} Clearing the \"dist\" directory... " do
        FileUtils.rm_rf "dist"
      end

      if Dir.exists?("public")
        terminal.measure "#{COG} Copying public folder contents... " do
          FileUtils.cp_r "public", "dist"
        end
      else
        FileUtils.mkdir "dist"
      end

      terminal.print "#{COG} Compiling your application:\n"
      File.write "dist/index.js", index

      terminal.measure "#{COG} Writing index.html... " do
        File.write "dist/index.html", IndexHtml.render(Environment::BUILD, relative, skip_service_worker)
      end

      terminal.measure "#{COG} Writing manifest.json..." do
        File.write "dist/manifest.json", manifest(json)
      end

      terminal.measure "#{COG} Generating icons... " do
        icons(json)
      end

      if !skip_service_worker
        terminal.measure "#{COG} Creating service worker..." do
          File.write "dist/service-worker.js", ServiceWorker.generate
        end
      end
    end

    def manifest(json)
      {
        "name"             => json.application.name,
        "short_name"       => json.application.name,
        "background_color" => json.application.theme,
        "theme_color"      => json.application.theme,
        "display"          => json.application.display,
        "orientation"      => json.application.orientation,
        "start_url"        => "/",
        "icons"            => ICON_SIZES.map do |size|
          {
            "src"   => "icon-#{size}x#{size}.png",
            "sizes" => "#{size}x#{size}",
            "type"  => "image/png",
          }
        end,
      }.to_pretty_json
    end

    def icons(json)
      ICON_SIZES.each do |size|
        destination =
          File.join("dist", "icon-#{size}x#{size}.png")

        icon =
          IconGenerator.convert(json.application.icon, size)

        File.write(destination, icon)
      end
    end

    def index
      runtime =
        Assets.read("runtime.js")

      sources =
        Dir.glob(SourceFiles.all)

      ast =
        Ast.new

      compiled = ""

      terminal.measure "  #{ARROW} Parsing #{sources.size} source files... " do
        sources.reduce(ast) do |memo, file|
          memo.merge Parser.parse(file)
          memo
        end
      end

      type_checker =
        TypeChecker.new(ast)

      terminal.measure "  #{ARROW} Type checking: " do
        type_checker.check
      end

      terminal.measure "  #{ARROW} Compiling: " do
        compiled = Compiler.compile type_checker.artifacts, {beautify: false}
      end

      runtime + compiled
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
