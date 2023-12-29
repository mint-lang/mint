module Mint
  class Compiler2
    include Helpers

    # Represents a compiled item
    alias Item = Ast::Node | Builtin | String | Signal | Indent | Raw | Variable

    # Represents an generated idetifier from the parts of the union type.
    alias Id = Ast::Node | Variable

    # Represents compiled code.
    alias Compiled = Array(Item)

    # Represents a Preact signal (https://preactjs.com/guide/v10/signals/). Signals are treated
    # differently from vaiables because we will need to access them using the `.value` accessor.
    record Signal, value : Ast::Node

    # Represents code which needs to be indented.
    record Indent, items : Compiled

    # Represents raw code (which does not get modified or indented).
    record Raw, value : String

    # Represents a variable.
    class Variable; end

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
      CreatePortal
      Fragment

      # Effects.
      UseDidUpdate
      UseComputed
      UseEffect
      UseSignal
      Computed
      Signal
      Batch

      # Providers.
      CreateProvider
      UseProviders

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
      ArrayAccess
      Translate
      Identity
      ToArray
      Compare
      Access
      Curry
      Or

      # Styles and CSS.
      InsertStyles
      Style

      # Test
      TestOperation
      TestContext
      TestRender
      TestRunner
    end

    delegate resolve_order, variables, cache, lookups, record_field_lookup, ast,
      to: artifacts

    # Contains the generated encoders.
    getter encoders = Hash(TypeChecker::Checkable, Compiled).new

    # Contains the generated decoders.
    getter decoders = Hash(TypeChecker::Checkable, Compiled).new

    # A set to track already rendered nodes.
    getter touched : Set(Ast::Node) = Set(Ast::Node).new

    # Contains the compiled JavaScript tree.
    getter compiled = [] of Tuple(Id, Compiled)

    # The type checker artifacts.
    getter artifacts : TypeChecker::Artifacts

    # The style builder instance.
    getter style_builder : StyleBuilder

    # The compiler config.
    getter config : Config

    # The JavaScript builder instance.
    getter js : Js

    def initialize(@artifacts, @config)
      @js =
        Js.new(optimize: config.optimize)

      @style_builder =
        StyleBuilder.new(
          css_prefix: config.css_prefix,
          optimize: config.optimize)
    end

    # Adds a compiled entity.
    def add(id : Id, value : Compiled)
      compiled << {id, value}
    end

    # Adds multiple compiled entities.
    def add(items : Array(Tuple(Id, Compiled) | Nil))
      items.compact.each { |(id, compiled)| add(id, compiled) }
    end

    # Compiles a node. If the node is already compiled or not checked it
    # returns an empty compiled node.
    def compile(node : Ast::Node, &)
      if touched.includes?(node) || !node.in?(artifacts.checked)
        [] of Item
      else
        touched.add(node)
        yield
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

    # Compiles the program call.
    def program
      routes =
        compile(ast.routes.flat_map(&.routes))

      js.call(Builtin::Program, [main, ok, js.array(routes)])
    end

    def inject_css(css : String)
      js.call(Builtin::InsertStyles, [[%(`#{css}`)] of Item])
    end

    # Compile test runner.
    def test(url, id)
      suites =
        compile(ast.suites)

      js.new(Builtin::TestRunner, [
        js.array(suites),
        [%("#{url}")] of Item,
        [id] of Item,
      ])
    end

    # These functions are for looking up entities that the runtime uses
    # (Just, Nothing, Err, Ok, Main).

    def main
      [ast.components.find!(&.name.value.==("Main"))] of Item
    end

    def maybe
      ast.type_definitions.find!(&.name.value.==("Maybe")).tap { |a| resolve a }
    end

    def result
      ast.type_definitions.find!(&.name.value.==("Result")).tap { |a| resolve a }
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