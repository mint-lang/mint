module Mint
  class Compiler2
    # This class is responsible to render `Compiled` code.
    class Renderer
      # The pool for class variables (uppercase).
      getter class_pool = NamePool(Ast::Node | Builtin, Nil).new('A'.pred.to_s)

      # The pool for variables (lowercase).
      getter pool = NamePool(Ast::Node | Variable, Nil).new

      # A set to track used builtins which will be imported.
      getter builtins = Set(Builtin).new

      # The current indentation depth.
      property depth : Int32 = 0

      def imports(optimize : Bool, runtime_path : String)
        return "" if builtins.empty?

        items =
          builtins.map do |item|
            "#{item.to_s.camelcase(lower: true)} as #{class_pool.of(item, nil)}"
          end.sort_by!(&.size).reverse!

        if items.size > 1 && !optimize
          %(import {\n#{items.join(",\n").indent}\n} from "#{runtime_path}")
        else
          %(import { #{items.join(",")} } from "#{runtime_path}")
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
      def render(item : Item, io : IO)
        case item
        in Signal
          # Signals are special becuse we need to use the `.value` accessor.
          io << "#{pool.of(item.value, nil)}.value"
        in Ast::Node
          # Nodes are compiled into variables.
          case item
          when Ast::TypeVariant,
               Ast::Component,
               Ast::Provider
            io << class_pool.of(item, nil)
          else
            io << pool.of(item, nil)
          end
        in Variable
          io << pool.of(item, nil)
        in Builtin
          io << class_pool.of(item, nil)

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
        in Indent
          self.depth += 1
          render(item.items, io)
          self.depth -= 1
        end
      end
    end
  end
end
