module Mint
  class Builder
    def initialize(relative, skip_service_worker, skip_icons, optimize, runtime_path)
      json = MintJson.parse_current

      if !skip_icons && !Process.find_executable("convert")
        terminal.puts("#{WARNING} ImageMagick is not installed, skipping icon generation...")
        skip_icons = true
      end

      terminal.measure "#{COG} Ensuring dependencies..." do
        json.check_dependencies!
      end

      terminal.measure "#{COG} Clearing the \"#{DIST_DIR}\" directory..." do
        FileUtils.rm_rf DIST_DIR
      end

      if Dir.exists?(PUBLIC_DIR)
        terminal.measure "#{COG} Copying \"#{PUBLIC_DIR}\" folder contents..." do
          FileUtils.cp_r PUBLIC_DIR, DIST_DIR
        end
      else
        FileUtils.mkdir DIST_DIR
      end

      terminal.puts "#{COG} Compiling your application:"

      index_js, artifacts =
        index(json.application.css_prefix, relative, optimize, runtime_path, json.web_components)

      File.write Path[DIST_DIR, "index.js"], index_js

      if SourceFiles.external_javascripts?
        terminal.measure "#{COG} Writing external javascripts..." do
          File.write Path[DIST_DIR, "external-javascripts.js"],
            SourceFiles.external_javascripts
        end
      end

      if SourceFiles.external_stylesheets?
        terminal.measure "#{COG} Writing external stylesheets..." do
          File.write Path[DIST_DIR, "external-stylesheets.css"],
            SourceFiles.external_stylesheets
        end
      end

      unless artifacts.assets.empty?
        asset_path =
          Path[DIST_DIR, ASSET_DIR].to_s

        FileUtils.mkdir(asset_path) unless Dir.exists?(asset_path)

        terminal.puts "#{COG} Writing assets..."

        assets =
          artifacts.assets.uniq(&.real_path).select!(&.exists?)

        assets.each do |asset|
          filename =
            asset.filename(build: true).not_nil!

          dest_path =
            Path[DIST_DIR, ASSET_DIR, filename]

          terminal.puts "  #{ARROW} #{filename}"

          File.write dest_path, asset.file_contents
        end
      end

      terminal.measure "#{COG} Writing index.html..." do
        File.write Path[DIST_DIR, "index.html"],
          IndexHtml.render(:build, relative, skip_service_worker, skip_icons)
      end

      terminal.measure "#{COG} Writing manifest.webmanifest..." do
        File.write Path[DIST_DIR, "manifest.webmanifest"],
          manifest(json, skip_icons)
      end

      unless skip_icons
        terminal.measure "#{COG} Generating icons..." do
          icons(json)
        end
      end

      unless skip_service_worker
        terminal.measure "#{COG} Creating service worker..." do
          File.write Path[DIST_DIR, "service-worker.js"],
            service_worker(artifacts, relative, optimize)
        end
      end
    end

    def manifest(json, skip_icons)
      application = json.application
      {
        "name"             => application.name,
        "short_name"       => application.name,
        "background_color" => application.theme,
        "theme_color"      => application.theme,
        "display"          => application.display,
        "orientation"      => application.orientation,
        "start_url"        => "/",
        "icons"            => manifest_icons(skip_icons),
      }.to_pretty_json
    end

    private def manifest_icons(skip_icons)
      return %w[] if skip_icons

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
          Path[DIST_DIR, "icon-#{size}x#{size}.png"]

        icon =
          IconGenerator.convert(json.application.icon, size)

        File.write(destination, icon)
      end
    end

    def index(css_prefix, relative, optimize, runtime_path, web_components)
      runtime =
        if runtime_path
          Cli.runtime_file_not_found(runtime_path) unless File.exists?(runtime_path)
          File.read(runtime_path)
        else
          Assets.read("runtime.js")
        end

      sources =
        Dir.glob(SourceFiles.all)

      ast =
        Ast.new
          .merge(Core.ast)

      terminal.measure "  #{ARROW} Parsing #{sources.size} source files..." do
        sources.reduce(ast) do |memo, file|
          memo.merge Parser.parse(file)
        end
      end

      type_checker =
        TypeChecker.new(ast, web_components: web_components.keys)

      terminal.measure "  #{ARROW} Type checking..." do
        type_checker.check
      end

      compiled = nil

      terminal.measure "  #{ARROW} Compiling..." do
        compiled = Compiler.compile type_checker.artifacts, {
          web_components: web_components,
          css_prefix:     css_prefix,
          relative:       relative,
          optimize:       optimize,
          build:          true,
        }
      end

      {runtime + compiled.to_s, type_checker.artifacts}
    end

    def get_service_worker_utils
      Assets.read("sw-utils.js")
    end

    def terminal
      Render::Terminal::STDOUT
    end

    def service_worker(artifacts, relative, optimize)
      worker = ServiceWorker.new(artifacts, relative, optimize)
      "#{get_service_worker_utils}#{worker}"
    end
  end
end
