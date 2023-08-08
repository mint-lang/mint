# TODO: Refactor this file into a different class because it should not be
# in the compiler.
module Mint
  class Compiler
    alias Options = NamedTuple(
      web_components: Hash(String, String),
      css_prefix: String?,
      optimize: Bool,
      relative: Bool,
      build: Bool,
    )

    DEFAULT_OPTIONS = Options.new(
      web_components: {} of String => String,
      css_prefix: nil,
      optimize: false,
      relative: false,
      build: false,
    )

    # Compiles the application with the runtime and the rendering of the $Main
    # component.
    def self.compile(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
      compiler =
        new(artifacts, **options)

      main =
        compiler.ast.components.find(&.name.value.==("Main")).try do |component|
          globals =
            compiler
              .ast
              .components
              .select(&.global?)
              .each_with_object({} of String => String) do |item, memo|
                name =
                  compiler.js.class_of(item)

                memo[name] = "$#{name}"
              end

          main_class =
            compiler.js.class_of(component)

          globals_object =
            compiler.js.object(globals)

          "\n_program.render(#{main_class}, #{globals_object})"
        end || ""

      compiler.wrap_runtime(compiler.compile, main)
    end

    def self.compile_embed(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
      compiler =
        new(artifacts, **options)

      main =
        compiler.ast.components.find(&.name.value.==("Main")).try do |component|
          globals =
            compiler
              .ast
              .components
              .select(&.global?)
              .each_with_object({} of String => String) do |item, memo|
                name =
                  compiler.js.class_of(item)

                memo[name] = "$#{name}"
              end

          main_class =
            compiler.js.class_of(component)

          globals_object =
            compiler.js.object(globals)

          "\n Mint.embed = (base) => (new mint.EmbeddedProgram(base)).render(#{main_class}, #{globals_object})"
        end || ""

      compiler.wrap_runtime(compiler.compile, main)
    end

    # Compiles the application without the runtime.
    def self.compile_bare(artifacts : TypeChecker::Artifacts, options = DEFAULT_OPTIONS) : String
      compiler =
        new(artifacts, **options)

      compiler.compile
    end

    # Compiles the application with the runtime and the tests
    def self.compile_with_tests(artifacts : TypeChecker::Artifacts) : String
      compiler =
        new(artifacts)

      compiler.wrap_runtime(compiler.compile(include_tests: true))
    end

    # Compiles the application
    def compile(include_tests : Bool = false) : String
      type_definitions =
        compile ast.type_definitions

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

      all_css =
        style_builder.compile

      footer =
        unless all_css.empty?
          ["_insertStyles(`\n#{all_css}\n`)"]
        end

      suites =
        if include_tests
          ["SUITES = [#{compile(ast.suites, ",")}]"]
        end

      static =
        static_components.map do |name, compiled|
          js.const("$#{name}", "_m(() => #{compiled})")
        end

      elements =
        (%w[] &+ type_definitions &+ modules &+ providers &+ routes &+ components &+ static &+ stores &+ footer &+ suites &+ compiled_web_components)
          .reject!(&.empty?)

      replace_skipped(js.statements(elements))
    end

    # --------------------------------------------------------------------------

    def maybe
      ast.type_definitions.find!(&.name.value.==("Maybe"))
    end

    def just
      node =
        case fields = maybe.fields
        when Array(Ast::TypeVariant)
          fields.find!(&.value.value.==("Just"))
        else
          raise "SHOULD NOT HAPPEN"
        end

      js.class_of(node)
    end

    def nothing
      node =
        case fields = maybe.fields
        when Array(Ast::TypeVariant)
          fields.find!(&.value.value.==("Nothing"))
        else
          raise "SHOULD NOT HAPPEN"
        end

      js.class_of(node)
    end

    # --------------------------------------------------------------------------

    def result
      ast.type_definitions.find!(&.name.value.==("Result"))
    end

    def ok
      node =
        case fields = result.fields
        when Array(Ast::TypeVariant)
          fields.find!(&.value.value.==("Ok"))
        else
          raise "SHOULD NOT HAPPEN"
        end

      js.class_of(node)
    end

    def err
      node =
        case fields = result.fields
        when Array(Ast::TypeVariant)
          fields.find!(&.value.value.==("Err"))
        else
          raise "SHOULD NOT HAPPEN"
        end

      js.class_of(node)
    end

    def compiled_web_components
      @web_components.compact_map do |component, tagname|
        node =
          ast.components.find(&.name.value.==(component))

        next unless node

        name =
          js.class_of(node)

        prefixed_name =
          if node.global?
            "$#{name}"
          else
            name
          end

        properties =
          compile node.properties.reject(&.name.value.==("children"))

        "_wc(#{prefixed_name}, '#{tagname}', #{js.array(properties)})"
      end
    end

    def compiled_locales
      mapped =
        locales.each_with_object({} of String => Hash(String, String)) do |(key, data), memo|
          data.each do |language, node|
            if node.in?(checked)
              memo[language] ||= {} of String => String
              memo[language]["'#{key}'"] = compile(node)
            end
          end
        end

      js.object(mapped.each_with_object({} of String => String) do |(language, tokens), memo|
        memo[language] = js.object(tokens)
      end)
    end

    # --------------------------------------------------------------------------

    # Wraps the application with the runtime
    def wrap_runtime(body, main = "")
      html_event_module =
        ast.unified_modules.find!(&.name.value.==("Html.Event"))

      from_event =
        html_event_module.functions.find!(&.name.value.==("fromEvent"))

      from_event_call =
        "#{js.class_of(html_event_module)}.#{js.variable_of(from_event)}"

      minimized_class_warning =
        unless build
          <<-JS
          console.warn("%c!!!DO NOT TARGET ELEMENTS WITH SELECTORS BECAUSE THE SELECTORS WILL BE MINIMIZED IN THE PRODUCTION BUILD!!!", "font-size: 2em")
          JS
        end

      <<-RESULT
      (() => {
        const _enums = {}
        const mint = Mint(_enums)

        const _normalizeEvent = (event) => {
          return #{from_event_call}(mint.normalizeEvent(event))
        }

        const _R = mint.createRecord
        const _h = mint.createElement
        const _createPortal = mint.createPortal
        const _insertStyles = mint.insertStyles
        const _navigate = mint.navigate
        const _compare = mint.compare
        const _program = mint.program
        const _encode = mint.encode
        const _style = mint.style
        const _array = mint.array
        const _wc = mint.register
        const _u = mint.update
        const _at = mint.at

        window.TestContext = mint.TestContext
        const TestContext = mint.TestContext
        const ReactDOM = mint.ReactDOM
        const Decoder = mint.Decoder
        const Encoder = mint.Encoder
        const DateFNS = mint.DateFNS
        const Record = mint.Record
        const React = mint.React

        const _C = mint.Component
        const _P = mint.Provider
        const _M = mint.Module
        const _S = mint.Store
        const _E = mint.Enum

        const _PR = (patterns) => new RecordPattern(patterns)
        const _PE = (x, pattern) => new Pattern(x, pattern)
        const _PV = Symbol("Variable")
        const _PS = Symbol("Spread")

        class Locale {
          constructor(translations) {
            this.locale = Object.keys(translations)[0];
            this.translations = translations;
            this.listeners = new Set();
          }

          set(locale) {
            if (this.locale != locale && this.translations[locale]) {
              this.locale = locale;

              for (let listener of this.listeners) {
                listener.forceUpdate();
              }

              return true
            } else {
              return false
            }
          }

          t(key) {
            return this.translations[this.locale][key]
          }

          _subscribe(owner) {
            this.listeners.add(owner);
          }

          _unsubscribe(owner) {
            this.listeners.delete(owner);
          }
        }

        const _L = new Locale(#{compiled_locales});

        class RecordPattern {
          constructor(patterns) {
            this.patterns = patterns
          }
        }

        class Pattern {
          constructor(x,pattern) {
            this.pattern = pattern;
            this.x = x;
          }
        }

        const __match = (value, pattern, values = []) => {
          if (pattern === null) {
          } else if (pattern === _PV) {
            values.push(value)
          } else if (Array.isArray(pattern)) { // This covers tuples and arrays (they are the same)
            const hasSpread = pattern.some((item) => item === _PS)

            if (hasSpread && value.length >= (pattern.length - 1)) {
              let endValues = []
              let startIndex = 0

              while (pattern[startIndex] !== _PS && startIndex < pattern.length) {
                if (!__match(value[startIndex], pattern[startIndex], values)) {
                  return false
                }
                startIndex++
              }

              let endIndex = 1

              while (pattern[pattern.length - endIndex] !== _PS && endIndex < pattern.length) {
                if (!__match(value[value.length - endIndex], pattern[pattern.length - endIndex], endValues)) {
                  return false
                }
                endIndex++
              }

              // Add in the spread
              values.push(value.slice(startIndex, value.length - (endIndex - 1)))

              // Add in the end values
              for (let item of endValues) {
                values.push(item)
              }
            } else {
              if (pattern.length !== value.length) {
                return false
              } else {
                for (let index in pattern) {
                  if (!__match(value[index], pattern[index], values)) {
                    return false
                  }
                }
              }
            }
          } else if (pattern instanceof Pattern) {
            if (value instanceof pattern.x) {
              if (pattern.pattern instanceof RecordPattern) {
                if (!__match(value, pattern.pattern, values)) {
                  return false
                }
              } else {
                for (let index in pattern.pattern) {
                  if (!__match(value[`_${index}`], pattern.pattern[index], values)) {
                    return false
                  }
                }
              }
            } else {
              return false
            }
          } else if (pattern instanceof RecordPattern) {
            for (let index in pattern.patterns) {
              const item = pattern.patterns[index];

              if (!__match(value[value._mapping[item[0]]], item[1], values)) {
                return false
              }
            }
          } else {
            if (!_compare(value, pattern)) {
              return false
            }
          }

          return values;
        }

        const _match = (value, patterns) => {
          for (let pattern of patterns) {
            if (pattern[0] === null) {
              return pattern[1]()
            } else {
              const values = __match(value, pattern[0]);

              if (values) {
                return pattern[1].apply(null, values)
              }
            }
          }
        }

        const _m = (method) => {
          let value
          return () => {
            if (value) { return value }
            value = method()
            return value
          }
        }

        const _o = (item, value) => {
          if (item !== undefined && item !== null) {
            return item;
          } else {
            return value;
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

        const _n = (item) => {
          return (...args) => new item(...args)
        }

        class DoError extends Error {}

        #{body}

        const Nothing = #{nothing}
        const Just = #{just}
        const Err = #{err}
        const Ok = #{ok}

        _enums.nothing = #{nothing}
        _enums.just = #{just}
        _enums.err = #{err}
        _enums.ok = #{ok}

        #{minimized_class_warning}
        #{main}
      })()
      RESULT
    end
  end
end
