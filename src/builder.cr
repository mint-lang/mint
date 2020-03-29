module Mint
  class Builder
    def initialize(relative, skip_service_worker, skip_icons)
      json = MintJson.parse_current

      terminal.measure "#{COG} Ensuring dependencies... " do
        json.check_dependencies!
      end

      terminal.measure "#{COG} Clearing the \"#{DIST_DIR}\" directory... " do
        FileUtils.rm_rf DIST_DIR
      end

      if Dir.exists?(PUBLIC_DIR)
        terminal.measure "#{COG} Copying \"#{PUBLIC_DIR}\" folder contents... " do
          FileUtils.cp_r PUBLIC_DIR, DIST_DIR
        end
      else
        FileUtils.mkdir DIST_DIR
      end

      terminal.puts "#{COG} Compiling your application:"
      File.write Path[DIST_DIR, "index.js"], index

      if SourceFiles.external_javascripts?
        terminal.measure "#{COG} Writing external javascripts..." do
          File.write Path[DIST_DIR, "external-javascripts.js"], SourceFiles.external_javascripts
        end
      end

      if SourceFiles.external_stylesheets?
        terminal.measure "#{COG} Writing external stylesheets..." do
          File.write Path[DIST_DIR, "external-stylesheets.css"], SourceFiles.external_stylesheets
        end
      end

      terminal.measure "#{COG} Writing index.html... " do
        File.write Path[DIST_DIR, "index.html"], IndexHtml.render(Environment::BUILD, relative, skip_service_worker, skip_icons)
      end

      terminal.measure "#{COG} Writing manifest.json..." do
        File.write "dist/manifest.json", manifest(json, skip_icons)
      end

      unless skip_icons
        terminal.measure "#{COG} Generating icons... " do
          icons(json)
        end
      end

      if !skip_service_worker
        terminal.measure "#{COG} Creating service worker..." do
          File.write "dist/service-worker.js", ServiceWorker.generate
        end
      end
    end

    def manifest(json, skip_icons)
      {
        "name"             => json.application.name,
        "short_name"       => json.application.name,
        "background_color" => json.application.theme,
        "theme_color"      => json.application.theme,
        "display"          => json.application.display,
        "orientation"      => json.application.orientation,
        "start_url"        => "/",
        "icons"            => manifest_icons(skip_icons),
      }.to_pretty_json
    end

    private def manifest_icons(skip_icons)
      return [] of String if skip_icons
      ICON_SIZES.map do |size|
        {
          "src"   => "icon-#{size}x#{size}.png",
          "sizes" => "#{size}x#{size}",
          "type"  => "image/png",
        }
      end
    end

    def icons(json)
      ICON_SIZES.each do |size|
        destination =
          File.join(DIST_DIR, "icon-#{size}x#{size}.png")

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
          .merge(Core.ast)

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
        compiled = Compiler.compile type_checker.artifacts, {optimize: true}
      end

      runtime + compiled
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
