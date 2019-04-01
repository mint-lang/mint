module Mint
  class Compiler
    DEFAULT_OPTIONS = {optimize: false}

    alias Options = NamedTuple(optimize: Bool)

    # Compiles the application with the runtime and the rendering of the $Main
    # component.
    def self.compile(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
      compiler =
        new(artifacts, options[:optimize])

      main =
        compiler.js.class_of(compiler.ast.components.find(&.name.==("Main")).not_nil!)

      compiler.wrap_runtime(compiler.compile + "\nconst $Main = #{main}\n_program.render($Main)")
    end

    # Compiles the application without the runtime.
    def self.compile_bare(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
      compiler = new(artifacts, options[:optimize])
      compiler.compile
    end

    # Compiles the application with the runtime and the tests
    def self.compile_with_tests(artifacts : TypeChecker::Artifacts) : String
      compiler =
        new(artifacts)

      base =
        compiler.compile

      tests =
        compiler.compile_tests

      compiler.wrap_runtime(base + "\n\n" + tests)
    end

    # Compiles the tests
    def compile_tests
      suites =
        compile ast.suites, ","

      "SUITES = [#{suites}]"
    end

    # Compiles the application
    def compile : String
      records =
        compile ast.records

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

      elements =
        enums + records + providers + routes + modules + components + stores + [footer]
          .reject(&.empty?)

      js.statements(elements)
    end

    # Wraps the application with the runtime
    def wrap_runtime(body)
      javascripts =
        SourceFiles
          .javascripts
          .map { |file| File.read(file) }
          .join("\n\n")

      html_event_module =
        ast.modules.find(&.name.==("Html.Event")).not_nil!

      from_event =
        html_event_module.functions.find(&.name.value.==("fromEvent")).not_nil!

      from_event_call =
        js.class_of(html_event_module) + "." + js.variable_of(from_event)

      <<-RESULT
      #{javascripts}

      (() => {
        const _normalizeEvent = function (event) {
          return #{from_event_call}(Mint.normalizeEvent(event))
        };

        const _R = Mint.createRecord;
        const _h = Mint.createElement;
        const _createPortal = Mint.createPortal;
        const _insertStyles = Mint.insertStyles;
        const _navigate = Mint.navigate;
        const _compare = Mint.compare;
        const _program = Mint.program;
        const _update = Mint.update;
        const _encode = Mint.encode;
        const _style = Mint.style;
        const _array = Mint.array;
        const _at = Mint.at;

        const TestContext = Mint.TestContext;
        const ReactDOM = Mint.ReactDOM;
        const Nothing = Mint.Nothing;
        const Decoder = Mint.Decoder;
        const DateFNS = Mint.DateFNS;
        const Record = Mint.Record;
        const React = Mint.React;
        const Just = Mint.Just;
        const Err = Mint.Err;
        const Ok = Mint.Ok;

        const _C = Mint.Component;
        const _P = Mint.Provider;
        const _M = Mint.Module;
        const _S = Mint.Store;
        const _E = Mint.Enum;

        class DoError extends Error {}

        #{body}
      })()
      RESULT
    end
  end
end
