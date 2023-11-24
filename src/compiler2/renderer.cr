module Mint
  class Compiler2
    # This class is responsible to render `Compiled` code.
    class Renderer
      # The pool for variables (lowercase).
      getter pool : NamePool(Ast::Node | Variable | String | Encoder | Decoder, Ast::Node | Bundle)

      # The pool for class variables (uppercase).
      getter class_pool : NamePool(Ast::Node | Builtin, Ast::Node | Bundle)

      # A set to track nodes which we rendered.
      getter used = Set(Ast::Node | Encoder | Decoder).new

      # A set to track used builtins which will be imported.
      getter builtins = Set(Builtin).new

      getter references : ReferencesTracker
      getter base : Ast::Node | Bundle

      getter deferred_path : Proc(Ast::Node | Bundle, String)
      getter bundle_path : Proc(Ast::Node | Bundle, String)

      # The current indentation depth.
      property depth : Int32 = 0

      def initialize(*, @base, @pool, @class_pool, @bundle_path, @deferred_path, @references)
      end

      def import(imports : Hash(String, String), optimize : Bool, path : String)
        return "" if imports.empty?

        items =
          imports
            .map do |(key, value)|
              if key == value
                key
              else
                "#{key} as #{value}"
              end
            end
            .sort_by!(&.size).reverse!

        if items.size > 1 && !optimize
          %(import {\n#{items.join(",\n").indent}\n} from "#{path}")
        else
          %(import { #{items.join(",")} } from "#{path}")
        end
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

      # We are using a string builder to build the final compiled code.
      def render(item : Item, io : IO = IO::Memory.new)
        case item
        in Signal
          used.add(item.value)

          # Signals are special becuse we need to use the `.value` accessor.
          io << "#{pool.of(item.value, base)}.value"
        in Ref
          # Signals are special becuse we need to use the `.current` accessor.
          io << "#{pool.of(item.value, base)}.current"
        in Ast::Node
          scope =
            case item
            when Ast::Property
              references.bundle_of(item)
            end || base

          used.add(item)

          # Nodes are compiled into variables.
          case item
          when Ast::TypeVariant,
               Ast::Component,
               Ast::Provider
            io << class_pool.of(item, scope)
            # io << "/* #{Debugger.dbg(item)} */"
          else
            io << pool.of(item, scope)
          end
        in Encoder, Decoder
          used.add(item)

          io << pool.of(item, base)
        in Variable
          io << pool.of(item, base)
        in Builtin
          io << class_pool.of(item, base)

          # We track the builtins here.
          builtins.add(item)
        in Raw
          io << item.value
        in String
          # Only strings need to be indented, and we copy everything and when
          # there is a new line we add the indentation after.
          item.each_char do |char|
            io << char
            io << (" " * depth * 2) if char == '\n'
          end
        in Deferred
          io << "`./#{deferred_path.call(item.value)}`"
        in Asset
          io << "`#{bundle_path.call(item.value)}`"
        in Indent
          self.depth += 1
          render(item.items, io)
          self.depth -= 1
        end
      end
    end
  end
end
