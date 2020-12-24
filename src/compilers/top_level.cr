# TODO: Refactor this file into a different class because it should not be
# in the compiler.
module Mint
  class Compiler
    alias Options = NamedTuple(
      css_prefix: String?,
      optimize: Bool,
      relative: Bool,
      build: Bool,
    )

    DEFAULT_OPTIONS = Options.new(
      css_prefix: nil,
      optimize: false,
      relative: false,
      build: false,
    )

    # Compiles the application with the runtime and the rendering of the $Main
    # component.
    def self.compile(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : Codegen::Node
      compiler =
        new(artifacts, **options)

      main =
        compiler.ast.components.find(&.name.==("Main")).try do |component|
          globals =
            compiler
              .ast
              .components
              .select(&.global?)
              .each_with_object({} of String => Codegen::Node) do |item, memo|
                name =
                  compiler.js.class_of(item)

                memo[name] = Codegen.join ["$", name]
              end

          main_class =
            compiler.js.class_of(component)

          globals_object =
            compiler.js.object(globals)

          Codegen.join ["\n_program.render(", main_class, ", ", globals_object, ")"]
        end || ""

      compiler.wrap_runtime(compiler.compile, main)
    end

    def self.compile_embed(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : Codegen::Node
      compiler =
        new(artifacts, **options)

      main =
        compiler.ast.components.find(&.name.==("Main")).try do |component|
          globals =
            compiler
              .ast
              .components
              .select(&.global?)
              .each_with_object({} of String => Codegen::Node) do |item, memo|
                name =
                  compiler.js.class_of(item)

                memo[name] = Codegen.join ["$", name]
              end

          main_class =
            compiler.js.class_of(component)

          globals_object =
            compiler.js.object(globals)

          Codegen.join ["\n Mint.embed = (base) => (new mint.EmbeddedProgram(base)).render(", main_class, ", ", globals_object, ")"]
        end || ""

      compiler.wrap_runtime(compiler.compile, main)
    end

    # Compiles the application without the runtime.
    def self.compile_bare(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
      compiler =
        new(artifacts, **options)

      Codegen.build(compiler.compile)[:code]
    end

    # Compiles the application with the runtime and the tests
    def self.compile_with_tests(artifacts : TypeChecker::Artifacts) : String
      compiler =
        new(artifacts)

      compiled =
        compiler.wrap_runtime(compiler.compile(include_tests: true))

      (Codegen.build compiled)[:code]
    end

    # Compiles the application
    def compile(include_tests : Bool = false) : Codegen::Node
      records =
        compile ast.records

      providers =
        compile ast.providers

      components =
        compile ast.components

      modules =
        compile ast.unified_modules

      stores =
        compile ast.stores

      routes =
        compile ast.routes

      enums =
        compile ast.enums

      all_css =
        style_builder.compile

      footer =
        if all_css.empty?
          ""
        else
          Codegen.join ["_insertStyles(`\n", all_css, "\n`)"]
        end

      suites =
        if include_tests
          [Codegen.join(["SUITES = [", compile(ast.suites, ","), "]"])]
        else
          [] of Codegen::Node
        end

      static =
        static_components.map do |name, compiled|
          js.const(
            "$#{name}",
            Codegen.join(["_m(() => ", compiled, ")"]))
        end

      elements =
        (enums &+ records &+ modules &+ providers &+ routes &+ components &+ static &+ stores &+ [footer] &+ suites)
          .reject! { |n| Codegen.empty? n }

      js.statements(elements)
    end

    # --------------------------------------------------------------------------

    def maybe
      ast.enums.find(&.name.==("Maybe")).not_nil!
    end

    def just
      node =
        maybe.options.find(&.value.==("Just")).not_nil!

      js.class_of(node)
    end

    def nothing
      node =
        maybe.options.find(&.value.==("Nothing")).not_nil!

      js.class_of(node)
    end

    # --------------------------------------------------------------------------

    def result
      ast.enums.find(&.name.==("Result")).not_nil!
    end

    def ok
      node =
        result.options.find(&.value.==("Ok")).not_nil!

      js.class_of(node)
    end

    def err
      node =
        result.options.find(&.value.==("Err")).not_nil!

      js.class_of(node)
    end

    # --------------------------------------------------------------------------

    # Wraps the application with the runtime
    def wrap_runtime(body : Codegen::Node, main : Codegen::Node = "") : Codegen::Node
      html_event_module =
        ast.unified_modules.find(&.name.==("Html.Event")).not_nil!

      from_event =
        html_event_module.functions.find(&.name.value.==("fromEvent")).not_nil!

      minimized_class_warning =
        unless build
          <<-JS
          console.warn("%c!!!DO NOT TARGET ELEMENTS WITH SELECTORS BECAUSE THE SELECTORS WILL BE MINIMIZED IN THE PRODUCTION BUILD!!!", "font-size: 2em")
          JS
        end

      from_event_call =
        Codegen.join [js.class_of(html_event_module), ".", js.variable_of(from_event)]

      Codegen.join [
        (
          <<-JS1
          (() => {
            const _enums = {}
            const mint = Mint(_enums)

            const _normalizeEvent = function (event) {
              return
          JS1
        ) + " ",
        from_event_call,
        (
          <<-JS2
           (mint.normalizeEvent(event))
            };

            const _R = mint.createRecord;
            const _h = mint.createElement;
            const _createPortal = mint.createPortal;
            const _insertStyles = mint.insertStyles;
            const _navigate = mint.navigate;
            const _compare = mint.compare;
            const _program = mint.program;
            const _encode = mint.encode;
            const _style = mint.style;
            const _array = mint.array;
            const _u = mint.update;
            const _at = mint.at;

            window.TestContext = mint.TestContext;
            const TestContext = mint.TestContext;
            const ReactDOM = mint.ReactDOM;
            const Decoder = mint.Decoder;
            const Encoder = mint.Encoder;
            const DateFNS = mint.DateFNS;
            const Record = mint.Record;
            const React = mint.React;

            const _C = mint.Component;
            const _P = mint.Provider;
            const _M = mint.Module;
            const _S = mint.Store;
            const _E = mint.Enum;

            const _m = (method) => {
              let value;
              return () => {
                if (value) { return value }
                value = method()
                return value
              }
            }

            const _s = (item, callback) => {
              if (item instanceof #{nothing}) {
                return item
              } else if (item instanceof #{just}) {
                return new #{just}(callback(item._0))
              } else {
                return callback(item)
              }
            }

            class DoError extends Error {}

          JS2
        ),
        body,
        (
          <<-JS3

            const Nothing = #{nothing}
            const Just = #{just}
            const Err = #{err}
            const Ok = #{ok}

            _enums.nothing = #{nothing}
            _enums.just = #{just}
            _enums.err = #{err}
            _enums.ok = #{ok}

          JS3
        ),
        minimized_class_warning,
        main,
        (
          <<-JS4

          })()
          JS4
        ),
      ].compact
    end
  end
end
