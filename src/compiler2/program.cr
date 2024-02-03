module Mint
  class Compiler2
    def self.bundle_name(node : Ast::Component | Nil)
      case node
      in Ast::Component
        "/__mint__/#{node.name.value.underscore}.js"
      in Nil
        "/index.js"
      end
    end

    def self.program(
      artifacts : TypeChecker::Artifacts,
      config : Config
    ) : Hash(String, String)
      compiler =
        new(artifacts, config)

      # Gather all top level entities and resolve them, this will populate the
      # `compiled` instance variable of the compiler.
      entities =
        artifacts.ast.type_definitions +
          artifacts.ast.unified_modules +
          artifacts.ast.components +
          artifacts.ast.providers +
          artifacts.ast.stores

      compiler.resolve(entities)

      # Compile the CSS.
      css =
        compiler.style_builder.compile

      # Compile tests if there is configration for it.
      tests =
        config.test.try do |(url, id)|
          [
            compiler.test(url, id),
            compiler.inject_css(css),
          ]
        end

      # This holds the to be compiled constants per components. `nil` holds
      # the ones meant for the main bundle.
      bundles =
        {
          nil => [] of Tuple(Ast::Node, Id, Compiled),
        } of Ast::Component | Nil => Array(Tuple(Ast::Node, Id, Compiled))

      # This holds which node belongs to which component.
      scopes =
        {} of Ast::Node => Ast::Component

      # Gather all of the IDs so we can use it to filter out imports later on.
      ids =
        compiler.compiled.map { |(_, id, _)| id }

      # We iterate through all references and decide in which bundle they
      # belong. All nodes that needs to be compiled should be in the references
      # map.
      artifacts.references.map do |node, set|
        # Gather all related nodes.
        nodes =
          compiler.compiled.select { |item| item[1] == node }

        # Delete the nodes so we know after which was not used so we can
        # add it to the main bundle.
        nodes.each { |item| compiler.compiled.delete(item) }

        case node
        when Ast::Component
          # We put async components into their own bundle.
          if node.async?
            bundles[node] ||= [] of Tuple(Ast::Node, Id, Compiled)
            bundles[node].concat(nodes)

            # Add the lazy component definition to the main bundle.
            bundles[nil] << {
              node,
              node,
              compiler.js.call(
                Builtin::Lazy,
                [["'", bundle_name(node), "'"] of Item]),
            }
          end
        end ||
          # If a node used in the main bundle or it two or more bundles then
          # it will go into the main bundle. Otherwise it will go to the
          # the bundle it's used from.
          if set.includes?(nil) || (!set.includes?(nil) && set.size >= 2)
            bundles[nil].concat(nodes)
          elsif component = set.first
            bundles[component] ||= [] of Tuple(Ast::Node, Id, Compiled)
            bundles[component].concat(nodes)

            # Assign the scope to the component
            scopes[node] = component
          end
      end

      # Add not already added items to the main bundle.
      bundles[nil].concat(compiler.compiled)

      rendered_bundles =
        {} of Ast::Component | Nil => Tuple(Renderer, Array(String))

      # We render the bundles so we can know after what we need to import.
      bundles.each do |component, contents|
        renderer =
          Renderer.new

        # Built the singe `const` with multiple assignments so we can add
        # things later to the array.
        items =
          if contents.empty?
            [] of Compiled
          else
            # Here we sort the compiled node by the order they are resovled, which
            # will prevent issues of one entity depending on others (like a const
            # depending on a function from a module).
            contents.sort_by! do |(node, id, _)|
              case node
              when Ast::TypeVariant
                -2 if node.value.value.in?("Just", "Nothing", "Err", "Ok")
              end || artifacts.resolve_order.index(node) || -1
            end

            [["export "] + compiler.js.consts(contents)]
          end

        # If we are building the main bundle we add the translations, tests
        # and the program.
        case component
        when Nil
          # Add translations and tests
          items.concat compiler.translations
          items.concat tests if tests

          # Add the program if needed.
          items << compiler.program if config.include_program
        end

        # Render the final JavaScript.
        items =
          items.reject(&.empty?).map { |item| renderer.render(item) }

        rendered_bundles[component] = {renderer, items}
      end

      modules =
        rendered_bundles.map do |node, (renderer, items)|
          # Main doesn't import from other nodes.
          # if node
          # This holds the imports for each other bundle.
          imports =
            {} of Ast::Component | Nil => Hash(String, String)

          renderer.used.map do |item|
            # We only need to import things that are actually exported (all
            # other entities show up here like function arguments statement
            # variables, etc...)
            next unless ids.includes?(item)

            # Get where the entity should be.
            target =
              scopes[item]?

            # If the target is not this bundle and it's not the same component
            # then we need to import.
            if target != node && item != node
              exported_name =
                rendered_bundles[target][0].render(item).to_s

              imported_name =
                renderer.render(item).to_s

              imports[target] ||= {} of String => String
              imports[target][exported_name] = imported_name
            end
          end

          # For each import we insert an import statment.
          imports.each do |target, data|
            items.unshift(renderer.import(data, config.optimize, bundle_name(target)))
          end

          items << "export default #{renderer.render(node)}" if node
          # end

          # Gather what builtins need to be imported and add it's statement
          # as well.
          builtins =
            renderer
              .builtins
              .each_with_object({} of String => String) do |item, memo|
                memo[item.to_s.camelcase(lower: true)] = renderer.class_pool.of(item, nil)
              end

          items
            .unshift(renderer.import(builtins, config.optimize, config.runtime_path))
            .reject!(&.blank?)

          js =
            if items.empty?
              ""
            elsif config.optimize
              items.join(";")
            else
              items.join(";\n\n") + ";"
            end

          {bundle_name(node), js}
        end

      modules << {"/index.css", css}
      modules.to_h
    end
  end
end
