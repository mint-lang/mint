module Mint
  module Codegen
    alias Node = String |
                 SourceMappable |
                 NodeContainer |
                 NodeIndent |
                 NodeNoIndent |
                 NodeStrip

    class NodeContainer
      def initialize(@nodes : Array(Node))
      end

      def to_s(io)
        io << (Codegen.build self)[:code]
        raise "Please use Codegen.join to concatenate Strings with nodes."
      end
    end

    class SourceMappable
      def initialize(@ast_node_from : Ast::Node?, @ast_node_to : Ast::Node, @node : Node, @is_symbol : Bool)
        symbol.try do |s|
          if s.includes?('\n')
            raise "symbol is supposed to be just a name, e.g. for a variable or a function but it is: #{s}"
          end
        end
      end

      def symbol
        @is_symbol ? file.input[from, to - from] : nil
      end

      def from
        (@ast_node_from || @ast_node_to).from
      end

      def to
        @ast_node_to.to
      end

      def file
        @ast_node_to.input
      end

      def to_s(io)
        raise "Please use Codegen.join to concatenate Strings with nodes."
      end
    end

    class NodeIndent
      def initialize(@child : Node, @spaces : Int32)
      end
    end

    class NodeNoIndent
      def initialize(@child : Node)
      end
    end

    class NodeStrip
      def initialize(@child : Node)
      end
    end

    def self.empty?(node : Node)
      case node
      in NodeContainer
        node.@nodes.all? { |n| empty?(n) }
      in String
        node.empty?
      in SourceMappable
        false
      in NodeIndent
        empty? node.@child
      in NodeNoIndent
        empty? node.@child
      in NodeStrip
        empty? node.@child
      end
    end

    def self.join(nodes : Array(Node), separator : String? = nil) : Node
      arr = [] of Node
      i = 0

      while i < nodes.size - 1
        node = nodes[i]
        arr << node

        if !separator.nil?
          arr << separator
        end
        i += 1
      end
      if !nodes.empty?
        arr << nodes.last
      end

      NodeContainer.new arr
    end

    def self.join(items, separator : String? = nil)
      Codegen.join(items.map { |i| yield i }, separator)
    end

    def self.source_mapped(ast_node : Ast::Node, node : Node) : Node
      SourceMappable.new(nil, ast_node, node, false)
    end

    def self.source_mapped(ast_node_from : Ast::Node, ast_node_to : Ast::Node, node : Node) : Node
      SourceMappable.new(ast_node_from, ast_node_to, node, false)
    end

    def self.symbol_mapped(ast_node : Ast::Node, node : Node) : Node
      SourceMappable.new(nil, ast_node, node, true)
    end

    def self.symbol_mapped(ast_node_from : Ast::Node, ast_node_to : Ast::Node, node : Node) : Node
      SourceMappable.new(ast_node_from, ast_node_to, node, true)
    end

    def self.indent(node : Node, spaces : Int32 = 2) : Node
      NodeIndent.new(node, spaces)
    end

    def self.indent(nodes : Array(Node), spaces : Int32 = 2) : Node
      indent(join(nodes), spaces)
    end

    def self.no_indent(node : Node) : Node
      NodeNoIndent.new(node)
    end

    def self.strip(node : Node) : Node
      NodeStrip.new(node)
    end

    def self.includes_endl?(node : Node) : Bool
      traverse = uninitialized Node -> Bool
      traverse = ->(cur : Node) {
        case cur
        in String
          cur.includes? '\n'
        in SourceMappable
          traverse.call cur.@node
        in NodeContainer
          cur.@nodes.any? { |n| traverse.call n }
        in NodeIndent
          traverse.call cur.@child
        in NodeNoIndent
          traverse.call cur.@child
        in NodeStrip
          false
        end
      }

      traverse.call(node)
    end

    def self.ends_with?(char : Char, node : Node) : Bool
      last_str = ""

      traverse = uninitialized Node -> Nil
      traverse = ->(cur : Node) {
        case cur
        in String
          last_str = cur
        in SourceMappable
          traverse.call cur.@node
        in NodeContainer
          cur.@nodes.each { |n| traverse.call n }
        in NodeIndent
          traverse.call cur.@child
        in NodeNoIndent
          traverse.call cur.@child
        in NodeStrip
          if char == ' ' || char == '\n'
            false
          else
            traverse.call cur.@child
          end
        end
      }

      traverse.call(node)
      last_str.ends_with? char
    end

    def self.build(node : Node, source_map = false) : NamedTuple(code: String, source_map: SourceMap?)
      builder = IndentedStringBuilder.new
      map = source_map ? SourceMap.new : nil

      traverse = uninitialized Node -> Nil
      traverse = ->(cur : Node) {
        case cur
        in String
          builder << cur
        in SourceMappable
          pos = builder.get_position_for_next_input
          dst_from_line = pos[:line]
          dst_from_col = pos[:column]

          traverse.call cur.@node

          map.try do |m|
            m.add_mapping(cur.file, cur.from, dst_from_line, dst_from_col, cur.symbol)
          end
        in NodeContainer
          cur.@nodes.each { |n| traverse.call n }
        in NodeIndent
          builder.indent_size += cur.@spaces
          traverse.call cur.@child
          builder.indent_size -= cur.@spaces
        in NodeNoIndent
          old_indent = builder.indent_size
          builder.indent_size = 0
          traverse.call cur.@child
          builder.indent_size = old_indent
        in NodeStrip
          builder.strip_whitespace_around do
            traverse.call cur.@child
          end
        end
      }

      traverse.call(node)

      {code: builder.build, source_map: map}
    end

    def self.build_with_mappings(node : Node) : Tuple(String, String)
      build(node, true)
    end
  end
end
