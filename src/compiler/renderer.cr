module Mint
  class Compiler
    # This class is responsible to render `Compiled` code.
    class Renderer
      # The pool for variables (lowercase).
      getter pool : NamePool(Ast::Node | Variable | String | Encoder | Decoder | Record, Set(Ast::Node) | Bundle)

      # The pool for class variables (uppercase).
      getter class_pool : NamePool(Ast::Node | Builtin, Set(Ast::Node) | Bundle)

      # The bundles which we use to get their filename.
      getter bundles : Hash(Set(Ast::Node) | Bundle, Set(Ast::Node))

      # A method to get the deffered path of a bundle.
      getter deferred_path : Proc(Set(Ast::Node) | Bundle, String)

      # A method to get the path of an asset.
      getter asset_path : Proc(Ast::Node, String)

      # The current bundle.
      getter base : Set(Ast::Node) | Bundle

      # Whether or not to generate source map mappings.
      getter? generate_source_maps : Bool

      # The exported entities.
      getter exported : Set(Ast::Node)

      # The last line index.
      property last_line : Int32 = 0

      # The current column.
      property column : Int32 = 0

      # The current indentation depth.
      property depth : Int32 = 0

      # The current line.
      property line : Int32 = 0

      alias Mapping = Tuple(Ast::Node | Nil, Tuple(Int32, Int32), String | Nil)

      # A mapping and stack for generating source maps. We use `Deque` because
      # we push and pop to the stack frequently.
      property stack : Deque(Ast::Node) = Deque(Ast::Node).new
      property mappings : Deque(Mapping) = Deque(Mapping).new

      def initialize(
        *,
        @generate_source_maps,
        @deferred_path,
        @class_pool,
        @asset_path,
        @exported,
        @bundles,
        @pool,
        @base,
      )
      end

      def render(items : Compiled) : String
        String.build do |io|
          render(items, io)
        end
      end

      def render(items : Compiled, io : IO) : Nil
        items.each do |item|
          render(item, io)
        end
      end

      def append(io : IO, value : String | Char)
        case value
        in Char
          io << value

          if generate_source_maps?
            last_mapping = mappings.last?.try(&.first)
            last_node = stack.last?

            if (last_mapping != last_node || last_line != line) && last_node
              name =
                case last_node
                when Ast::Argument,
                     Ast::Function,
                     Ast::Property,
                     Ast::Signal,
                     Ast::State,
                     Ast::Get
                  last_node.name.value
                when Ast::Variable
                  last_node.value
                end

              mappings << {last_node, {line, column}, name}
              self.last_line = line
            end

            case value
            when '\n'
              self.column = 0
              self.line += 1
            else
              self.column += 1
            end
          end
        in String
          value.each_char do |char|
            append(io, char)
          end
        end

        true
      end

      # We are using a string builder to build the final compiled code.
      def render(item : Item, io : IO = IO::Memory.new)
        case item
        in SourceMapped
          @stack.push(item.node)
          render(item.value, io).tap { @stack.pop }
        in Await
          append(io, "await")
        in Function
          render(item.value, io)
        in Signal
          # Signals are special becuse we need to use the `.value` accessor.
          append(io, "#{pool.of(item.value, base)}.value")
        in Ref
          # Refs are special becuse we need to use the `.current` accessor.
          append(io, "#{pool.of(item.value, base)}.current")
        in Ast::Node
          scope =
            case item
            when Ast::Property
              bundles.find(&.last.includes?(item)).try(&.first)
            end || base

          # Nodes are compiled into variables.
          case item
          when Ast::TypeVariant,
               Ast::Component,
               Ast::Provider
            append(io, class_pool.of(item, scope))
          else
            parent =
              item.parent

            case {parent, item}
            when {Ast::Component, Ast::Property}
              append(io, item.name.value) if parent.in?(exported)
            end || append(io, pool.of(item, scope))
          end
        in Encoder, Decoder, Record, Variable
          append(io, pool.of(item, base))
        in Builtin
          append(io, class_pool.of(item, base))
        in Raw
          append(io, item.value)
        in String
          # Only strings need to be indented, and we copy everything and when
          # there is a new line we add the indentation after.
          item.each_char do |char|
            append(io, char)
            append(io, (" " * depth * 2)) if char == '\n'
          end
        in Deferred
          bundle =
            bundles.find!(&.last.includes?(item.value)).first

          append(io, "`./#{deferred_path.call(bundle)}`")
        in Asset
          append(io, "`#{asset_path.call(item.value)}`")
        in Indent
          self.depth += 1
          render(item.items, io)
          self.depth -= 1
        end

        io
      end
    end
  end
end
