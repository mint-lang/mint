module Mint
  # This class handles the generation of a serializer of Mint types into
  # JavaScript Objects.
  #
  # The type checker ensures that types are decodeable / encodeable so anything
  # that raises should not happen but it's needed for the crystal type checker.
  class Compiler2
    @mappings = {} of String => Tuple(Variable, Variable, Compiled)

    def encoder(type : TypeChecker::Record) : Compiled
      @encoders[type] ||= begin
        node =
          ast.type_definitions.find!(&.name.value.==(type.name))

        item =
          type.fields.each_with_object({} of String => Compiled) do |(key, value), memo|
            encoder =
              self.encoder value

            if mapping = type.mappings[key]?
              encoder = js.array([encoder, [%("#{mapping}")] of Item])
            end

            memo[key] = encoder
          end

        [
          Variable.new.tap do |variable|
            add variable, js.call(Builtin::Encoder, [js.object(item)])
          end,
        ] of Item
      end
    end

    def encoder(type : TypeChecker::Type) : Compiled
      case type.name
      when "Time"
        [Builtin::EncodeTime] of Item
      when "Array"
        js.call(Builtin::EncodeArray, [encoder(type.parameters.first)])
      when "Maybe"
        js.call(Builtin::EncodeMaybe, [encoder(type.parameters.first)])
      when "Map"
        js.call(Builtin::EncodeMap, [encoder(type.parameters.last)])
      when "Tuple"
        encoders =
          type.parameters.map { |item| encoder(item) }

        js.call(Builtin::EncodeTuple, encoders)
      else
        ["null"] of Item
      end
    end

    def encoder(node : TypeChecker::Variable)
      raise "Cannot generate an encoder for a type variable!"
    end
  end

  class Compiler2
    include Helpers

    alias Item = Ast::Node | Builtin | String | Signal | Indent | Raw | Variable
    alias Id = Ast::Node | Variable
    alias Compiled = Array(Item)

    record Signal, value : Ast::Node
    record Indent, items : Compiled
    record Raw, value : String

    class Variable
    end

    enum Builtin
      PatternVariable
      PatternSpread
      PatternRecord
      Pattern
      Destructure
      Match

      NewVariant
      Variant

      CreateElement
      Fragment

      UseDidUpdate
      UseComputed
      UseEffect
      UseSignal
      Computed
      Signal
      Batch

      CreateProvider
      UseProviders

      EncodeTuple
      EncodeArray
      EncodeMaybe
      EncodeTime
      EncodeMap
      Encoder

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

      NormalizeEvent
      InsertStyles
      ArrayAccess
      Translate
      Navigate
      Program
      ToArray
      Compare
      Access
      Curry
      Style
      Or
    end

    class JsRenderer
      getter used_builtins = Set(Builtin).new
      property depth : Int32 = 0

      def initialize(*, @runtime_path : String = "runtime")
        @pool =
          NamePool(Ast::Node | Variable, Nil).new

        @class_pool =
          NamePool(Ast::Node | Builtin, Nil).new('A'.pred.to_s)
      end

      def imports
        return nil if used_builtins.empty?

        items =
          used_builtins.map do |item|
            "#{item.to_s.camelcase(lower: true)} as #{@class_pool.of(item, nil)}"
          end.sort_by(&.size).reverse

        if items.size > 1
          %(import {\n#{items.join(",\n").indent}\n} from "#{@runtime_path}")
        else
          %(import { #{items.join(",")} } from "#{@runtime_path}")
        end
      end

      def program(main : Ast::Component, ok : Compiled, routes : Array(Compiled))
        used_builtins.add(Builtin::Program)

        rendered =
          render(routes.flatten)

        "#{@class_pool.of(Builtin::Program, nil)}(#{@class_pool.of(main, nil)}, #{render(ok)}, #{rendered})"
      end

      def render(items : Compiled) : String
        String.build do |io|
          render(items, io)
        end
      end

      def render(items : Compiled, io : IO)
        items.each do |item|
          render(item, io)
        end
      end

      def render(item : Item, io : IO)
        case item
        in Signal
          io << "#{@pool.of(item.value, nil)}.value"
        in Ast::Node
          case item
          when Ast::Component,
               Ast::TypeVariant,
               Ast::Provider
            io << @class_pool.of(item, nil)
          else
            io << @pool.of(item, nil)
          end
        in Variable
          io << @pool.of(item, nil)
        in Builtin
          used_builtins.add(item)
          io << @class_pool.of(item, nil)
        in Raw
          io << item.value
        in String
          item.each_char do |char|
            io << char
            io << (" " * @depth * 2) if char == '\n'
          end
        in Indent
          @depth += 1
          render(item.items, io)
          @depth -= 1
        end
      end
    end

    class Js
      getter optimize

      def initialize(@optimize : Bool = false)
      end

      def object(items : Hash(Item, Compiled)) : Compiled
        return ["{}"] of Item if items.empty?

        fields =
          join(
            items.map { |key, value| [key, ": "] + value },
            optimize ? "," : ",\n")

        block(fields)
      end

      def object_destructuring(items : Array(Compiled)) : Compiled
        return ["{}"] of Item if items.empty?

        fields =
          join(items, optimize ? "," : ",\n")

        block(fields)
      end

      def call(name : Item | Compiled, arguments : Array(Compiled)) : Compiled
        case name
        in Compiled
          name + ["("] + list(arguments) + [")"]
        in Item
          [name, "("] + list(arguments) + [")"]
        end
      end

      def array(items : Array(Compiled)) : Compiled
        if optimize || items.size <= 1
          ["["] + list(items) + ["]"]
        else
          ["[", Indent.new(["\n"] + list(items, multiline: true)), "\n]"] of Item
        end
      end

      def statements(items : Array(Compiled)) : Compiled
        join(items.reject(&.empty?), optimize ? ";" : ";\n")
      end

      def const(name : Item | Compiled, value : Compiled) : Compiled
        ["const "] + assign(name, value)
      end

      def consts(items : Array(Tuple(Id, Compiled))) : Compiled
        if items.size == 1
          id, value = items[0]
          const id, value
        else
          assigns =
            items.map { |(id, compiled)| assign(id, compiled) }

          if optimize
            ["const "] + list(assigns, multiline: false)
          else
            ["const"] + [Indent.new(["\n"] + list(assigns, multiline: true))] of Item
          end
        end
      end

      def new(name : Item | Compiled, items : Array(Compiled)) : Compiled
        ["new "] + call(name, items)
      end

      def let(variables : Array(Variable)) : Compiled
        ["let "] + variables.map(&.as(Item)).intersperse(optimize ? "," : ", ")
      end

      def let(name : Item | Compiled, value : Compiled) : Compiled
        ["let "] + assign(name, value)
      end

      def assign(name : Item | Compiled, value : Compiled) : Compiled
        case name
        in Compiled
          name + [optimize ? "=" : " = "] + value
        in Item
          ([name, optimize ? "=" : " = "] of Item) + value
        end
      end

      def if(condition : Compiled, body : Compiled) : Compiled
        ["if#{optimize ? "(" : " ("}"] +
          condition + [optimize ? ")" : ") "] +
          block(body)
      end

      def if_shorthand(condition : Compiled, truthy : Compiled, falsy : Compiled)
        ["("] +
          condition +
          [optimize ? "?" : " ? "] +
          truthy +
          [optimize ? ":" : " : "] +
          falsy +
          [")"]
      end

      def for(varibales : Compiled, subject : Compiled) : Compiled
        ["for", optimize ? "(" : " ("] +
          varibales +
          [" of "] +
          subject +
          [optimize ? ")" : ") "] +
          block(yield)
      end

      def return(item : Compiled)
        ["return "] + item
      end

      def asynciif : Compiled
        function([] of Compiled, async: true, invoke: true) { yield }
      end

      def iif : Compiled
        function([] of Compiled, async: false, invoke: true) { yield }
      end

      def async_arrow_function(arguments : Array(Compiled) = [] of Compiled) : Compiled
        function(arguments, async: true, invoke: false) { yield }
      end

      def arrow_function(arguments : Array(Compiled) = [] of Compiled) : Compiled
        function(arguments, async: false, invoke: false) { yield }
      end

      private def list(arguments : Array(Compiled), *, multiline : Bool = false) : Compiled
        if multiline
          join(arguments, ",\n")
        else
          join(arguments, optimize ? "," : ", ")
        end
      end

      private def function(arguments : Array(Compiled) = [] of Compiled, *, async : Bool, invoke : Bool)
        keyword =
          if async
            "async "
          else
            ""
          end

        items =
          block(yield)

        head, tail, parens =
          if invoke
            ["(", ")", "()"]
          else
            ["", "", ""]
          end

        ["#{head}#{keyword}("] +
          list(arguments) +
          [optimize ? ")=>" : ") => "] +
          items +
          ["#{tail}#{parens}"]
      end

      private def block(items : Compiled) : Compiled
        if optimize
          ["{"] + items + ["}"]
        else
          [Indent.new(["{\n"] + items), "\n}"] of Item
        end
      end

      private def join(items : Array(Compiled), separator : String) : Compiled
        items.reject(&.empty?).intersperse([separator]).flatten
      end
    end

    delegate resolve_order, argument_order, variables, cache, lookups,
      record_field_lookup, ast, to: @artifacts

    @compiled = [] of Tuple(Id, Compiled)
    @touched : Set(Ast::Node) = Set(Ast::Node).new

    @encoders = Hash(TypeChecker::Checkable, Compiled).new
    @decoders = Hash(TypeChecker::Checkable, Compiled).new

    def add(id : Id, compiled : Compiled)
      @compiled << {id, compiled}
    end

    def add(items : Array(Tuple(Id, Compiled) | Nil))
      items.compact.each { |(id, compiled)| add(id, compiled) }
    end

    def compile(node : Ast::Node)
      if @touched.includes?(node) || !node.in?(@artifacts.checked)
        [] of Item
      else
        @touched.add(node)
        yield
      end
    end

    def resolve(nodes : Array(Ast::Node))
      nodes.map { |node| resolve(node) }
    end

    def resolve(node : Ast::Node)
      puts "Missing resolver for: #{node.class.to_s.upcase}"
      nil
    end

    def resolve(node : Ast::Node)
      return unless node.in?(@artifacts.checked)
      return if @touched.includes?(node)
      @touched.add(node)
      yield
    end

    getter js, compiled, style_builder

    getter relative : Bool = false
    getter build : Bool = true

    def initialize(@artifacts : TypeChecker::Artifacts)
      @js = Js.new(optimize: false)

      @style_builder =
        StyleBuilder.new(css_prefix: nil, optimize: false)
    end

    def compile(nodes : Array(Ast::Node), separator : String) : Compiled
      compile(nodes).intersperse([separator]).flatten
    end

    def compile(nodes : Array(Ast::Node)) : Array(Compiled)
      nodes.map { |node| compile(node) }
    end

    def compile(node : Ast::Node) : Compiled
      puts "Missing compiler for: #{node.class.to_s.upcase}"
      ["null"] of Item
    end

    def maybe
      ast.type_definitions.find!(&.name.value.==("Maybe")).tap { |a| resolve a }
    end

    def just
      case fields = maybe.fields
      when Array(Ast::TypeVariant)
        [fields.find!(&.value.value.==("Just"))] of Item
      else
        raise "SHOULD NOT HAPPEN"
      end
    end

    def nothing
      case fields = maybe.fields
      when Array(Ast::TypeVariant)
        [fields.find!(&.value.value.==("Nothing"))] of Item
      else
        raise "SHOULD NOT HAPPEN"
      end
    end

    def result
      ast.type_definitions.find!(&.name.value.==("Result")).tap { |a| resolve a }
    end

    def ok
      case fields = result.fields
      when Array(Ast::TypeVariant)
        [fields.find!(&.value.value.==("Ok"))] of Item
      else
        raise "SHOULD NOT HAPPEN"
      end
    end

    def err
      case fields = result.fields
      when Array(Ast::TypeVariant)
        [fields.find!(&.value.value.==("Err"))] of Item
      else
        raise "SHOULD NOT HAPPEN"
      end
    end

    def self.compile(
      artifacts : TypeChecker::Artifacts,
      *,
      runtime_path : String,
      include_program : Bool
    ) : String
      renderer = JsRenderer.new(runtime_path: runtime_path)

      top_level =
        artifacts.ast.type_definitions +
          (artifacts.ast.unified_modules +
            artifacts.ast.components +
            artifacts.ast.providers +
            artifacts.ast.stores).sort_by { |item| artifacts.resolve_order.index(item) || -1 }

      compiler =
        new(artifacts).tap(&.resolve(top_level))

      routes =
        compiler.compile(artifacts.ast.routes)

      all_css =
        compiler.style_builder.compile

      items =
        if compiler.compiled.empty?
          [] of Compiled
        else
          [compiler.js.consts(compiler.compiled)]
        end

      unless all_css.empty?
        items << compiler.js.call(Builtin::InsertStyles, [["`\n#{all_css}\n`"] of Item])
      end

      items = items.map { |item| renderer.render(item) }

      if include_program
        items.push(renderer.program(
          artifacts.ast.components.find!(&.name.value.==("Main")),
          compiler.ok,
          routes))
      end

      imports =
        renderer.imports

      items.unshift(imports) if imports

      if items.empty?
        ""
      else
        items.join(";\n\n") + ";"
      end
    end
  end
end
