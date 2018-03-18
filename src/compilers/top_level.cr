require "duktape/runtime"

class Compiler
  RUNTIME = Duktape::Runtime.new do |sbx|
    sbx.eval!("var global = {}")
    sbx.eval! Assets.read("js_beautify.js")
  end

  DEFAULT_OPTIONS = {beautify: true}

  alias Options = NamedTuple(beautify: Bool)

  def self.compile(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
    compiler = new(artifacts)

    if options[:beautify]
      RUNTIME.call(["global", "js_beautify"], compiler.compile, {indent_size: 2}).to_s
    else
      compiler.compile
    end
  end

  def compile : String
    providers =
      compile ast.providers

    components =
      compile ast.components

    modules =
      compile ast.modules

    stores =
      compile ast.stores

    routes =
      compile ast.routes

    media_css =
      medias.map do |condition, rules|
        selectors =
          rules.map do |name, items|
            definitions =
              items
                .map { |key, value| "#{key}: #{value};" }
                .join("\n")
                .indent

            ".#{name} {\n#{definitions}\n}"
          end.join("\n\n")
             .indent

        "@media #{condition} {\n#{selectors}\}"
      end.join("\n\n")
         .indent

    css =
      styles.map do |name, items|
        definitions =
          items
            .map { |key, value| "#{key}: #{value};" }
            .join("\n")
            .indent

        ".#{name} {\n#{definitions}\n}"
      end.join("\n\n")
         .indent

    footer =
      if css.strip.empty?
        ""
      else
        "Mint.insertStyles(`\n#{css + media_css}\n`)"
      end

    (providers + routes + modules + stores + components + [footer])
      .reject(&.empty?)
      .join("\n\n")
  end
end
