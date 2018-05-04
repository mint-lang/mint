module Mint
  class Compiler
    RUNTIME = Duktape::Runtime.new do |sbx|
      sbx.eval!("var global = {}")
      sbx.eval! Assets.read("js_beautify.js")
    end

    DEFAULT_OPTIONS = {beautify: true}

    alias Options = NamedTuple(beautify: Bool)

    def self.compile(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
      compiler = new(artifacts)

      result = compiler.wrap_runtime(compiler.compile + "\n_program.render($Main)")

      if options[:beautify]
        RUNTIME.call(["global", "js_beautify"], result, {indent_size: 2}).to_s
      else
        result
      end
    end

    def self.compile_bare(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
      compiler = new(artifacts)

      if options[:beautify]
        RUNTIME.call(["global", "js_beautify"], compiler.compile, {indent_size: 2}).to_s
      else
        compiler.compile
      end
    end

    def self.compile_with_tests(artifacts : TypeChecker::Artifacts) : String
      compiler = new(artifacts)
      base = compiler.compile
      tests = compiler.compile_tests
      compiler.wrap_runtime(base + "\n\n" + tests)
    end

    def compile_tests
      suites =
        compile ast.suites, ","

      "SUITES = [#{suites}]"
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

      enums =
        compile ast.enums

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
          "_insertStyles(`\n#{css + media_css}\n`)"
        end

      (enums + providers + routes + modules + stores + components + [footer])
        .reject(&.empty?)
        .join("\n\n")
    end

    def wrap_runtime(body)
      <<-RESULT
    (() => {
      const _normalizeEvent = Mint.normalizeEvent;
      const _createElement = Mint.createElement;
      const _createPortal = Mint.createPortal;
      const _insertStyles = Mint.insertStyles;
      const _navigate = Mint.navigate;
      const _compare = Mint.compare;
      const _program = Mint.program;
      const _update = Mint.update;

      const TestContext = Mint.TestContext;
      const Component = Mint.Component;
      const ReactDOM = Mint.ReactDOM;
      const Provider = Mint.Provider;
      const Nothing = Mint.Nothing;
      const DateFNS = Mint.DateFNS;
      const Record = Mint.Record;
      const Store = Mint.Store;
      const Just = Mint.Just;
      const Err = Mint.Err;
      const Ok = Mint.Ok;

      class DoError extends Error {}

      #{body}
    })()
    RESULT
    end
  end
end
