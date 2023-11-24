module Mint
  class Compiler2
    include Helpers

    # Represents a compiled item
    alias Item = Ast::Node | Builtin | String | Signal | Indent | Raw |
                 Variable | Ref | Encoder | Decoder | Asset | Deferred

    # Represents an generated idetifier from the parts of the union type.
    alias Id = Ast::Node | Variable | Encoder | Decoder

    # Represents compiled code.
    alias Compiled = Array(Item)

    # Represents an reference to a file
    record Asset, value : Ast::Node | Bundle

    # Represents an reference to a deferred file
    record Deferred, value : Ast::Node

    # Represents a Preact signal (https://preactjs.com/guide/v10/signals/). Signals are treated
    # differently from vaiables because we will need to access them using the `.value` accessor.
    record Signal, value : Ast::Node

    # Represents a reference to an HTML element or other component. They are treated differently
    # because they have a `.current` accessor.
    record Ref, value : Ast::Node

    # Represents code which needs to be indented.
    record Indent, items : Compiled

    # Represents raw code (which does not get modified or indented).
    record Raw, value : String

    # Represents a variable.
    class Variable; end

    # Represents an encoder.
    class Encoder; end

    # Represents a decoder.
    class Decoder; end

    enum Bundle
      Index
    end

    # Builtin functions in the runtime.
    enum Builtin
      # Pattern matching.
      PatternVariable
      PatternSpread
      PatternRecord
      Destructure
      Pattern
      Match

      # Type variants.
      NewVariant
      Variant

      # Rendering.
      CreateElement
      LazyComponent
      CreatePortal
      Fragment
      Lazy

      # Effects.
      UseDidUpdate
      UseComputed
      UseFunction
      UseEffect
      CreateRef
      UseSignal
      Computed
      UseMemo
      UseRef
      Signal
      Batch

      # Providers.
      CreateProvider
      Subscriptions
      UseId
      Uuid

      # Encoders.
      EncodeTuple
      EncodeArray
      EncodeMaybe
      EncodeTime
      EncodeMap
      Encoder

      # Decoders.
      DecodeBoolean
      DecodeObject
      DecodeString
      DecodeNumber
      DecodeField
      DecodeMaybe
      DecodeArray
      DecodeTuple
      DecodeTime
      DecodeMap
      Decoder

      # Navigation and program.
      Navigate
      Program

      # Utilities.
      NormalizeEvent
      BracketAccess
      MapAccess
      Identity
      ToArray
      Compare
      Define
      SetRef
      Access
      Curry
      Load
      Or

      # Styles and CSS.
      InsertStyles
      Style

      # Test
      TestOperation
      TestContext
      TestRender
      TestRunner

      # Translations
      Translations
      Translate
      SetLocale
      Locale
    end

    delegate record_field_lookup, ast, components_touched, to: artifacts
    delegate resolve_order, variables, cache, lookups, to: artifacts

    # Contains the generated encoders.
    getter encoders = Hash(TypeChecker::Checkable, Compiled).new

    # Contains the generated decoders.
    getter decoders = Hash(TypeChecker::Checkable, Compiled).new

    # A set to track already rendered nodes.
    getter touched : Set(Ast::Node) = Set(Ast::Node).new

    # Contains the compiled JavaScript tree.
    getter compiled = [] of Tuple(Ast::Node, Id, Compiled)

    # The type checker artifacts.
    getter artifacts : TypeChecker::Artifacts

    # The style builder instance.
    getter style_builder : StyleBuilder

    # The compiler config.
    getter config : Bundler::Config

    # The JavaScript builder instance.
    getter js : Js

    def initialize(@artifacts, css_prefix, @config)
      @js =
        Js.new(optimize: config.optimize)

      @style_builder =
        StyleBuilder.new(css_prefix: css_prefix, optimize: config.optimize)
    end

    # Adds a compiled entity.
    def add(node : Ast::Node, id : Id, value : Compiled)
      compiled << {node, id, value}
    end

    # Adds multiple compiled entities.
    def add(items : Array(Tuple(Ast::Node, Id, Compiled) | Nil))
      items.compact.each { |(node, id, compiled)| add(node, id, compiled) }
    end

    # Compiles a node. If the node is already compiled or not checked it
    # returns an empty compiled node.
    def compile(node : Ast::Node, &) : Compiled
      if touched.includes?(node) || !node.in?(artifacts.checked)
        [] of Item
      else
        yield.tap { touched.add(node) }
      end
    end

    # Compiles multiple nodes and joins them with the separator.
    def compile(nodes : Array(Ast::Node), separator : String) : Compiled
      compile(nodes).intersperse([separator]).flatten
    end

    # Compiles multiple nodes.
    def compile(nodes : Array(Ast::Node)) : Array(Compiled)
      nodes.map { |node| compile(node) }
    end

    # Fallback for compiling a node.
    def compile(node : Ast::Node) : Compiled
      raise "Missing compiler for: #{node.class.to_s.upcase}"
    end

    # Resolves a top-level node.
    def resolve(node : Ast::Node, &)
      return unless node.in?(artifacts.checked)
      return if touched.includes?(node)
      touched.add(node)
      yield
    end

    # Resolves top-level nodes.
    def resolve(nodes : Array(Ast::Node))
      nodes.map { |node| resolve(node) }
    end

    # Fallback resolving nodes.
    def resolve(node : Ast::Node)
      puts "Missing resolver for: #{node.class.to_s.upcase}"
      nil
    end

    # Translations
    def translations
      mapped =
        artifacts
          .locales
          .each_with_object({} of String => Hash(String, Compiled)) do |(key, data), memo|
            data.each do |language, node|
              if node.in?(artifacts.checked)
                memo[language] ||= {} of String => Compiled
                memo[language]["'#{key}'"] = compile(node)
              end
            end
          end

      object =
        mapped.each_with_object({} of String => Compiled) do |(language, tokens), memo|
          memo[language] = js.object(tokens)
        end

      if object.empty?
        [[] of Item]
      else
        [
          js.assign([Builtin::Translations, ".value"] of Item, js.object(object)),
          js.assign([Builtin::Locale, ".value"] of Item, js.string(object.keys.first)),
        ]
      end
    end

    # Compiles the program call.
    def program
      main.try do |component|
        routes =
          compile(ast.routes.flat_map(&.routes))

        globals =
          ast
            .components
            .select(&.global?)
            .each_with_object({} of Item => Compiled) do |item, memo|
              memo[item.as(Item)] = [item] of Item
            end

        ["export default "] + js.arrow_function do
          js.call(Builtin::Program, [
            [component] of Item,
            js.object(globals),
            ok,
            js.array(routes),
          ])
        end
      end || [] of Item
    end

    def inject_css(css : String)
      js.call(Builtin::InsertStyles, [[%(`#{css}`)] of Item])
    end

    # Compile test runner.
    def test(url, id)
      suites =
        compile(ast.suites)

      ["export default "] + js.arrow_function do
        js.new(Builtin::TestRunner, [
          js.array(suites),
          js.string(url),
          js.string(id),
        ])
      end
    end

    # These functions are for looking up entities that the runtime uses
    # (Just, Nothing, Err, Ok, Main).

    def main
      ast.components.find(&.name.value.==("Main"))
    end

    def maybe
      ast
        .type_definitions
        .find!(&.name.value.==("Maybe"))
        .tap { |node| resolve node }
    end

    def result
      ast
        .type_definitions
        .find!(&.name.value.==("Result"))
        .tap { |node| resolve node }
    end

    def just
      [
        maybe
          .fields
          .as(Array(Ast::TypeVariant))
          .find!(&.value.value.==("Just")),
      ] of Item
    end

    def nothing
      [
        maybe
          .fields
          .as(Array(Ast::TypeVariant))
          .find!(&.value.value.==("Nothing")),
      ] of Item
    end

    def ok
      [
        result
          .fields
          .as(Array(Ast::TypeVariant))
          .find!(&.value.value.==("Ok")),
      ] of Item
    end

    def err
      [
        result
          .fields
          .as(Array(Ast::TypeVariant))
          .find!(&.value.value.==("Err")),
      ] of Item
    end
  end
end
