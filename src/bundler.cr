module Mint
  # This class is responsible for compiling and building the application.
  class Bundler
    alias Bundle = Compiler::Bundle

    record Config,
      test : NamedTuple(url: String, id: String, glob: String)?,
      generate_source_maps : Bool,
      generate_manifest : Bool,
      include_program : Bool,
      runtime_path : String?,
      hash_routing : Bool,
      live_reload : Bool,
      hash_assets : Bool,
      skip_icons : Bool,
      json : MintJson,
      optimize : Bool

    # The end result of the bundling. It contains the all the files for the
    # application.
    getter files = {} of String => Proc(String)

    # The artifacts to bundle.
    getter artifacts : TypeChecker::Artifacts

    # The bundle configuration.
    getter config : Config

    # Contains the names of the bundles.
    getter bundle_names = {} of Set(Ast::Node) | Bundle => String

    delegate application, to: json
    delegate json, to: config

    def initialize(*, @config, @artifacts)
      @bundle_counter = 0
    end

    def bundle
      Logger.log "Building application" { generate_application }
      Logger.log "Generating index.html" { generate_index_html }
      Logger.log "Generating manifest" { generate_manifest } if config.generate_manifest
      Logger.log "Generating icons" { generate_icons } unless config.skip_icons
      Logger.log "Copying assets" { generate_assets }

      files
    end

    def generate_application
      compiler =
        Compiler.new(artifacts, application.css_prefix, config)

      Logger.log "Compiling intermediate representation..." do
        # Gather all top level entities and resolve them, this will populate the
        # `compiled` instance variable of the compiler.
        (artifacts.ast.type_definitions +
          artifacts.ast.unified_modules +
          artifacts.ast.components +
          artifacts.ast.providers +
          artifacts.ast.stores).tap { |items| compiler.resolve(items) }
      end

      # Compile the CSS.
      files[path_for_asset("index.css")] =
        -> do
          Logger.log "Generating index.css" do
            compiler.style_builder.compile
          end
        end

      tests =
        if test_information = config.test
          # Compile tests if there is configration for it.
          Logger.log "Compiling tests" do
            [
              compiler.test(**test_information),
            ]
          end
        end

      # This holds the to be compiled constants per bundle. `Bundle::Index` holds
      # the ones meant for the main bundle.
      bundles =
        {
          Bundle::Index => ([] of Tuple(Ast::Node, Compiler::Id, Compiler::Compiled)),
        } of Set(Ast::Node) | Bundle => Array(Tuple(Ast::Node, Compiler::Id, Compiler::Compiled))

      # This holds which node belongs to which bundle.
      scopes =
        {} of Compiler::Id => Set(Ast::Node)

      # Gather all of the IDs so we can use it to filter out imports later on.
      ids =
        compiler.compiled.map { |(_, id, _)| id }

      calculated_bundles =
        Logger.log "Calculating dependencies for bundles..." do
          # Calculate the bundles.
          artifacts.references.calculate
        end

      Logger.log "Bundling and generating JavaScript..." do
        # NOTE: For debugging purposes.
        # puts "Compiled entities:"
        # compiler.compiled.each do |(a, b, c)|
        #   puts " -> #{Debugger.dbg(a)}, #{Debugger.dbg(b)}"
        # end

        # Here we separate the compiled items to each bundle.
        calculated_bundles.each do |node, dependencies|
          case node
          when Set(Ast::Node)
            next unless node.any?(&.in?(artifacts.checked))
          end

          # NOTE: For debugging purposes.
          # puts "Bundle for #{Debugger.dbg(node)}:"
          # dependencies.each do |dep|
          #   puts " -> #{Debugger.dbg(dep)}"
          # end

          bundles[node] =
            dependencies.flat_map do |dependency|
              compiler.compiled.select { |item| item[0] == dependency }
            end

          bundles[node].try(&.each do |item|
            case node
            when Set(Ast::Node)
              scopes[item[1]] = node
            end
          end)
        end

        # NOTE: For debugging purposes.
        # bundles.each do |key, items|
        #   puts "Bundle #{Debugger.dbg(key)}:"
        #   items.each do |(a, b, c)|
        #     puts " -> #{Debugger.dbg(a)}, #{Debugger.dbg(b)}"
        #   end
        # end

        # Here we add async components to a bundle so they can be loaded
        # and referenced in the virtual DOM.
        artifacts
          .ast
          .nodes
          .select(Ast::HtmlComponent)
          .select(&.component_node.try(&.async?))
          .select(&.in?(artifacts.checked))
          .map do |item|
            {item.component_node.not_nil!, calculated_bundles.find!(&.last.includes?(item)).first}
          end
          .uniq!
          .map do |(component, bundle)|
            bundles[bundle]?.try(&.unshift({
              component,
              component,
              compiler.js.call(
                Compiler::Builtin::Lazy,
                [[Compiler::Deferred.new(component)] of Compiler::Item]),
            }))
          end

        class_pool =
          NamePool(Ast::Node | Compiler::Builtin, Set(Ast::Node) | Bundle).new('A'.pred.to_s)

        pool =
          NamePool(Compiler::Variable |
                   Compiler::Encoder |
                   Compiler::Decoder |
                   Compiler::Record |
                   Ast::Node |
                   String, Set(Ast::Node) | Bundle).new

        processed_bundles =
          {} of Set(Ast::Node) | Bundle => Tuple(Compiler::Renderer, Array(Compiler::Compiled))

        # We render the bundles so we can know after what we need to import.
        bundles.each do |node, contents|
          renderer =
            Compiler::Renderer.new(
              deferred_path: ->bundle_name(Set(Ast::Node) | Bundle),
              generate_source_maps: config.generate_source_maps,
              exported: artifacts.exported,
              bundles: calculated_bundles,
              class_pool: class_pool,
              base: node,
              pool: pool,
              asset_path: ->(item : Ast::Node) do
                path = asset_path(item)
                path = "./#{path}" if config.hash_routing
                path
              end)

          # Build the single `const` with multiple assignments so we can add
          # things later to the array.
          items =
            if contents.empty?
              [] of Compiler::Compiled
            else
              # Here we sort the compiled node by the order they are resovled, which
              # will prevent issues of one entity depending on others (like a const
              # depending on a function from a module).
              contents.sort_by! do |(node, id, _)|
                case id
                when Ast::TypeVariant
                  -2 if id.value.value.in?("Just", "Nothing", "Err", "Ok")
                end || artifacts.resolve_order.index(node) || -1
              end

              [["export "] + compiler.js.consts(contents)]
            end

          # If we are building the main bundle we add the translations, tests
          # and the program.
          case node
          when Bundle::Index
            # Add translations and tests
            items.concat compiler.translations
            items.concat tests if tests

            # Add the program if needed.
            items << compiler.program if config.include_program
            items << compiler.exports
          end

          processed_bundles[node] = {renderer, items.reject(&.empty?)}
        end

        rendered_bundles =
          processed_bundles.map do |node, (renderer, items)|
            used =
              compiler.gather_used(items)

            case node
            when Bundle::Index
              # Index doesn't import from other nodes.
            else
              # This holds the imports for each other bundle.
              imports =
                {} of Set(Ast::Node) | Bundle => Hash(String, String)

              used.map do |item|
                # We only need to import things that are actually exported (all
                # other entities show up here like function arguments, statement
                # variables, etc...)
                next unless ids.includes?(item)

                # We don't import async components.
                case item
                when Ast::Id
                  next # NOTE: Don't know how this can be here...
                when Ast::Component
                  next if item.async?
                end

                # Get where the entity should be.
                target =
                  scopes[item]? || Bundle::Index

                # If the target is not this bundle and it's not the same bundle
                # then we need to import.
                if target != node && Set.new([item]) != node
                  exported_name =
                    processed_bundles[target][0].render(item).to_s

                  imported_name =
                    renderer.render(item).to_s

                  imports[target] ||= {} of String => String
                  imports[target][exported_name] = imported_name
                end
              end

              # For each import we insert an import statement.
              imports.each do |target, data|
                items.unshift(compiler.js.import(data, path_for_import(target)))
              end

              case node
              in Bundle::Index
              in Set(Ast::Node)
                if node.size == 1
                  items << ["export default ", node.first] of Compiler::Item
                end
              end
            end

            # Gather what builtins need to be imported and add it's statement
            # as well.
            builtins =
              used
                .select(Compiler::Builtin)
                .each_with_object({} of String => String) do |item, memo|
                  memo[item.to_s.camelcase(lower: true)] = renderer.class_pool.of(item, node)
                end

            items
              .unshift(compiler.js.import(builtins, "./runtime.js"))
              .reject!(&.empty?)

            path =
              path_for_bundle(node)

            js =
              if items.empty?
                ""
              else
                renderer.render(compiler.js.statements(items, line_count: 2)) + ";"
              end

            files[path] = -> { js }

            {renderer, path, js}
          end

        if config.generate_source_maps
          Logger.log "Generating source maps..." do
            rendered_bundles.each do |(renderer, path, js)|
              source_map_path =
                "#{path}.map"

              source_map =
                SourceMapGenerator.new(renderer.mappings, js).generate

              files[path] = -> { "#{js}\n//# sourceMappingURL=#{File.basename(source_map_path)}" }
              files[source_map_path] = -> { source_map }
            end
          end
        end
      end
    end

    def generate_index_html
      files["/index.html"] = -> do
        HtmlBuilder.build(optimize: config.optimize) do
          html do
            head do
              meta charset: application.meta["charset"]? || "utf-8"

              if config.generate_manifest
                link rel: "manifest", href: "manifest.webmanifest"
              end

              application.meta.each do |name, content|
                next if name == "charset"
                meta name: name, content: content
              end

              unless application.theme_color.blank?
                meta name: "theme-color", content: application.theme_color
              end

              if generate_icons?
                ICON_SIZES.each do |size|
                  link href: path_for_asset("icon-#{size}x#{size}.png"),
                    size: "#{size}x#{size}",
                    type: "image/png",
                    rel: "icon"
                end

                {152, 167, 180}.each do |size|
                  link href: path_for_asset("icon-#{size}x#{size}.png"),
                    rel: "apple-touch-icon-precomposed"
                end
              end

              unless application.title.blank?
                title { text application.title }
              end

              raw application.head

              link rel: "stylesheet", href: path_for_asset("index.css")
            end

            body do
              if config.live_reload
                script src: path_for_asset("live-reload.js")
              end

              script type: "module" do
                path = path_for_asset("index.js")
                path = "./#{path}" if config.hash_routing

                raw <<-TEXT
                import Program from "#{path}"
                Program()
                TEXT
              end

              noscript do
                text "This application requires JavaScript."
              end

              if item = config.test
                script do
                  raw %(window.TEST_ID = "#{item[:id]}";)
                end

                div id: "root"
              end
            end
          end
        end
      end
    end

    def generate_manifest
      files["/manifest.webmanifest"] = -> do
        icons =
          if generate_icons?
            ICON_SIZES.map do |size|
              {
                "src"   => "icon-#{size}x#{size}.png",
                "sizes" => "#{size}x#{size}",
                "type"  => "image/png",
              }
            end
          else
            %w[]
          end
        {
          "orientation"      => application.orientation,
          "background_color" => application.theme_color,
          "theme_color"      => application.theme_color,
          "display"          => application.display,
          "name"             => application.name,
          "short_name"       => application.name,
          "icons"            => icons,
          "start_url"        => "/",
        }.to_pretty_json
      end
    end

    def generate_icons?
      !config.skip_icons &&
        Process.find_executable("convert") &&
        File.exists?(json.application.icon)
    end

    def generate_icons
      return unless generate_icons?

      ICON_SIZES.each do |size|
        files[path_for_asset("icon-#{size}x#{size}.png")] =
          -> { IconGenerator.convert(json.application.icon, size) }
      end
    end

    def generate_assets
      artifacts
        .assets
        .uniq(&.real_path)
        .select!(&.exists?)
        .each do |asset|
          path =
            path_for_asset(asset.filename(build: config.hash_assets))

          files[path] = -> { asset.file_contents }
        end

      if Dir.exists?(PUBLIC_DIR)
        Dir.glob(Path[PUBLIC_DIR, "**", "*"], follow_symlinks: true).each do |path|
          next if File.directory?(path)

          parts =
            Path[path].parts.tap(&.shift)

          files["/#{parts.join("/")}"] = -> { File.read(path) }
        end
      end

      files[path_for_asset("runtime.js")] =
        if runtime_path = config.runtime_path
          # TODO: Raise if runtime not found
          -> { File.read(runtime_path) }
        elsif config.test
          -> { Assets.read("runtime_test.js") }
        else
          -> { Assets.read("runtime.js") }
        end

      if config.live_reload
        files[path_for_asset("live-reload.js")] =
          -> { Assets.read("live-reload.js") }
      end
    end

    def bundle_name(node : Set(Ast::Node) | Bundle) : String
      @bundle_names[node] ||= begin
        case node
        in Bundle::Index
          "index.js"
        in Set(Ast::Node)
          "#{@bundle_counter += 1}.js"
        end
      end
    end

    def asset_path(node : Ast::Node)
      case node
      when Ast::Directives::FileBased
        path_for_asset(node.filename(build: config.hash_assets))
      else
        ""
      end
    end

    def path_for_asset(filename : String) : String
      prefix =
        if config.hash_routing
          ""
        else
          "/#{ASSET_DIR}/"
        end

      "#{prefix}#{filename}"
    end

    def path_for_import(node : Set(Ast::Node) | Bundle) : String
      "./#{bundle_name(node)}"
    end

    def path_for_bundle(node : Set(Ast::Node) | Bundle) : String
      path_for_asset(bundle_name(node))
    end
  end
end
