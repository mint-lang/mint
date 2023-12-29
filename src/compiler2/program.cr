module Mint
  class Compiler2
    def self.spec(
      artifacts : TypeChecker::Artifacts,
      config : Config
    ) : String
      renderer =
        Renderer.new(config)

      compiler =
        new(artifacts, config)

      entities =
        artifacts.ast.type_definitions +
          artifacts.ast.unified_modules +
          artifacts.ast.components +
          artifacts.ast.providers +
          artifacts.ast.stores

      compiler.resolve(entities)

      css =
        compiler.style_builder.compile

      compiler.compiled.sort_by! do |(id, _)|
        case id
        when Ast::Node
          artifacts.resolve_order.index(id)
        end || 0
      end

      items =
        if compiler.compiled.empty?
          [] of Compiled
        else
          [compiler.js.consts(compiler.compiled)]
        end

      items =
        items.map { |item| renderer.render(item) }

      imports =
        renderer.imports

      items.unshift(imports) if imports

      js =
        if items.empty?
          ""
        elsif config.optimize
          items.join(";")
        else
          items.join(";\n\n") + ";"
        end

      js + "\n\n" + css
    end

    def self.test(
      artifacts : TypeChecker::Artifacts,
      config : Config,
      url : String
    ) : String
      renderer =
        Renderer.new(config)

      compiler =
        new(artifacts, config)

      entities =
        artifacts.ast.type_definitions +
          artifacts.ast.unified_modules +
          artifacts.ast.components +
          artifacts.ast.providers +
          artifacts.ast.stores

      compiler.resolve(entities)

      css =
        compiler.style_builder.compile

      tests =
        compiler.test(url, "TEST_ID")

      compiler.compiled.sort_by! do |(id, _)|
        case id
        when Ast::Node
          artifacts.resolve_order.index(id)
        end || 0
      end

      items =
        if compiler.compiled.empty?
          [] of Compiled
        else
          [compiler.js.consts(compiler.compiled)]
        end

      items << tests
      items << compiler.inject_css(css)

      items =
        items.map { |item| renderer.render(item) }

      imports =
        renderer.imports

      items.unshift(imports) if imports

      js =
        if items.empty?
          ""
        elsif config.optimize
          items.join(";")
        else
          items.join(";\n\n") + ";"
        end

      js
    end

    def self.program(
      artifacts : TypeChecker::Artifacts,
      config : Config
    ) : Tuple(String, String)
      renderer =
        Renderer.new(config)

      compiler =
        new(artifacts, config)

      entities =
        artifacts.ast.type_definitions +
          (
            artifacts.ast.unified_modules +
              artifacts.ast.components +
              artifacts.ast.providers +
              artifacts.ast.stores
          ).sort_by { |item| artifacts.resolve_order.index(item) || -1 }

      compiler.resolve(entities)

      css =
        compiler.style_builder.compile

      items =
        if compiler.compiled.empty?
          [] of Compiled
        else
          [compiler.js.consts(compiler.compiled)]
        end

      items << compiler.program

      items =
        items.map { |item| renderer.render(item) }

      imports =
        renderer.imports

      items.unshift(imports) if imports

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
