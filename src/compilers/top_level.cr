module Mint
  class Compiler
    RUNTIME = Duktape::Runtime.new do |sbx|
      sbx.eval!("var global = {}")
      sbx.eval! Assets.read("js_beautify.js")
    end

    DEFAULT_OPTIONS = {beautify: true}

    alias Options = NamedTuple(beautify: Bool)

    # Compiles the application with the runtime and the rendering of the $Main
    # component.
    def self.compile(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
      compiler =
        new(artifacts)

      result =
        compiler.wrap_runtime(compiler.compile + "\n_program.render($Main)")

      if options[:beautify]
        RUNTIME.call(["global", "js_beautify"], result, {indent_size: 2}).to_s
      else
        result
      end
    end

    # Compiles the application without the runtime.
    def self.compile_bare(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
      compiler = new(artifacts)

      if options[:beautify]
        RUNTIME.call(["global", "js_beautify"], compiler.compile, {indent_size: 2}).to_s
      else
        compiler.compile
      end
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

      (enums + records + providers + routes + modules + components + stores + [footer])
        .reject(&.empty?)
        .join("\n\n")
    end

    # Wraps the application with the runtime
    def wrap_runtime(body)
      javascripts =
        SourceFiles
          .javascripts
          .map { |file| File.read(file) }
          .join("\n\n")

      <<-RESULT
      #{javascripts}

      (() => {
        const _normalizeEvent = Mint.normalizeEvent;
        const _createElement = Mint.createElement;
        const _createPortal = Mint.createPortal;
        const _insertStyles = Mint.insertStyles;
        const _navigate = Mint.navigate;
        const _compare = Mint.compare;
        const _program = Mint.program;
        const _update = Mint.update;
        const _encode = Mint.encode;
        const _at = Mint.at;
        const _array = function() {
          let items = Array.from(arguments)
          if (Array.isArray(items[0]) && items.length === 1) {
            return items[0]
          } else {
            return items
          }
        }

        const _style = function(items) {
          const result = {}
          for (let item of items) {
            if (item instanceof Map) {
              for (let [key, value] of item) {
                result[key] = value
              }
            } else {
              for (let key in item) {
                result[key] = item[key]
              }
            }
          }
          return result
        }

        const TestContext = Mint.TestContext;
        const ReactDOM = Mint.ReactDOM;
        const Provider = Mint.Provider;
        const Nothing = Mint.Nothing;
        const Decoder = Mint.Decoder;
        const DateFNS = Mint.DateFNS;
        const Record = Mint.Record;
        const Store = Mint.Store;
        const React = Mint.React;
        const Just = Mint.Just;
        const Enum = Mint.Enum;
        const Err = Mint.Err;
        const Ok = Mint.Ok;

        class DoError extends Error {}

        const excludedMethods = [
          'componentWillMount',
          'UNSAFE_componentWillMount',
          'render',
          'getSnapshotBeforeUpdate',
          'componentDidMount',
          'componentWillReceiveProps',
          'UNSAFE_componentWillReceiveProps',
          'shouldComponentUpdate',
          'componentWillUpdate',
          'UNSAFE_componentWillUpdate',
          'componentDidUpdate',
          'componentWillUnmount',
          'componentDidCatch',
          'setState',
          'forceUpdate',
          'constructor'
        ]

        const bindFunctions = (target) => {
          const descriptors =
            Object.getOwnPropertyDescriptors(Reflect.getPrototypeOf(target))

          for (let key in descriptors) {
            if (excludedMethods[key]) { continue }
            const value = descriptors[key].value
            if (typeof value !== "function") { continue }
            target[key] = value.bind(target)
          }
        }

        class Module {
          constructor() {
            bindFunctions(this)
          }
        }

        class Component extends Mint.Component {
          constructor(props) {
            super(props)
            bindFunctions(this)
          }
        }
        #{body}
      })()
      RESULT
    end
  end
end
