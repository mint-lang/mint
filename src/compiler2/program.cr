module Mint
  class Compiler2
    def self.program(
      artifacts : TypeChecker::Artifacts,
      config : Config
    ) : Tuple(String, String)
      renderer =
        Renderer.new

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

      # Here we sort the compiled node by the order they are resovled, which
      # will prevent issues of one entity depending on others (like a const
      # depending on a function from a module).
      compiler.compiled.sort_by! do |(node, id, y)|
        case node
        when Ast::TypeVariant
          -2 if node.value.value.in?("Just", "Nothing", "Err", "Ok")
        end || artifacts.resolve_order.index(node) || -1
      end

      # Built the singe `const` with multiple assignments so we can add
      # things later to the array.
      items =
        if compiler.compiled.empty?
          [] of Compiled
        else
          [compiler.js.consts(compiler.compiled)]
        end

      # Add translations and tests
      items.concat compiler.translations
      items.concat tests if tests

      # Add the program if needed.
      items << compiler.program if config.include_program

      # Render the final JavaScript and add imports.
      items =
        items
          .reject(&.empty?)
          .map { |item| renderer.render(item) }
          .unshift(renderer.imports(config.optimize, config.runtime_path))
          .reject(&.empty?)

      js =
        if items.empty?
          ""
        elsif config.optimize
          items.join(";")
        else
          items.join(";\n\n") + ";"
        end

      {js, css}
    end
  end
end
