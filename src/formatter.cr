module Mint
  class Formatter
    class Config
      property indent_size : Int32

      def initialize(@indent_size = 2)
      end
    end

    # Alias for a node.
    alias Node = NestedString | BreakNotFits | BrokenString | Entity | String |
                 Group | Line | Nest | List

    # Alias for array of nodes.
    alias Nodes = Array(Node)

    # A nested value (indented by one extra level).
    record Nest, items : Nodes

    # New line(s).
    record Line, count : Int32

    # Describes a key, value pair. It will break the value (second value of
    # the tuple) into a new indented line if the whole key, value pair doesn't
    # fit in a line.
    record BreakNotFits, items : Tuple(Nodes, Nodes), separator : String

    # Describes an entity (mostly function definition). If the whole thing
    # does not fit in one line then the arguments are broken into their own
    # lines.
    record Entity, head : Nodes, arguments : Array(Nodes), tail : Nodes

    # Describes a group of items where the leading whitespace is set to a
    # fixed amount (on top of the current indentation).
    record NestedString, items : Array(String | Nodes), indentation : Int32

    # Describes a broken string ("Hello" \ "There") and contains logic to
    # break the string just so that it fits with the maxmimum column length.
    # It tries to break by words but will break words that doens't fit in the
    # remaning column width.
    record BrokenString, items : Array(String | Nodes)

    # Describes a list that is formatted like so:
    #
    # - Multiline items, comments, documentation comments and consecutive block
    #   comments are separated from other items with double lines.
    #
    record List,
      items : Array(Tuple(Ast::Node, Nodes)),
      separator : String? = nil

    # Describes a group of nodes, with start and end characters and a separator
    # character (or characters). The layout of the nodes are determined during
    # rendering based on the behavior:
    #
    # `BreakAll`:
    #
    # - If the whole group fits in the remaning space in the line (current
    #   cursor position plus the size of the group) it will use a space as a
    #   delimeter.
    #
    # - Otherwise the delimeter will include a line-break and the nodes will be
    #   layed out in separate lines indented by an extra level. The start
    #   character is on the original line and the end character in it's own
    #   extra line.
    #
    # `BreakNotFits`:
    #
    # - If the whole group fits in the remaning space in the line (current
    #   cursor position plus the size of the group) it will use a space as a
    #   delimeter.
    #
    # - Otherwise the elements that would not extend beyong the current line
    #   are broken down into a new indented line and so forth...
    #
    # `Block`:
    #
    # - The group is always broken into a nested layout, separators are not
    #   indented.
    #
    record Group,
      ends : Tuple(String, String),
      items : Array(Nodes),
      behavior : Behavior,
      separator : String,
      pad : Bool

    # The possibilities on how to format groups.
    enum Behavior
      BreakNotFits
      BreakAll
      Block
    end

    # Represents a processed string of formatted source code,
    # ready to be rendered.
    alias Processed = LineBreak | String

    class LineBreak
      property count : Int32
      getter depth : Int32

      def initialize(@count, @depth)
      end
    end

    # The configuration.
    getter config : Config

    def initialize(@config)
    end

    # Helpers for creating nodes...

    def nested_string(**params)
      [NestedString.new(**params)] of Node
    end

    def broken_string(**params)
      [BrokenString.new(**params)] of Node
    end

    def break_not_fits(**params)
      [BreakNotFits.new(**params)] of Node
    end

    def entity(**params)
      [Entity.new(**params)] of Node
    end

    def group(**params)
      [Group.new(**params)] of Node
    end

    def list(**params)
      [List.new(**params)] of Node
    end

    # Actuall formatting things as strings...

    def format!(*args, **named) : String
      Renderer.render(format(*args, **named))
    end

    def format!(value : Nil) : Nil
    end

    # Helpers for recursively formatting things...

    def format_arguments(
      nodes : Array(Ast::Node), *,
      empty_parenthesis = true
    ) : Nodes
      return empty_parenthesis ? ["()"] of Node : [] of Node if nodes.empty?

      behavior =
        if nodes.all?(Ast::TypeDefinitionField)
          Behavior::BreakAll
        else
          case items = nodes
          when Array(Ast::Field)
            Behavior::BreakAll if items.all?(&.key)
          end
        end || Behavior::BreakNotFits

      [
        Group.new(
          items: nodes.map(&->format(Ast::Node)),
          behavior: behavior,
          ends: {"(", ")"},
          separator: ",",
          pad: false),
      ] of Node
    end

    def format_documentation_comment(node : Ast::Comment?) : Nodes
      node.try { |item| format(item) + [Line.new(1)] } || [] of Node
    end

    def format(nodes : Array(Ast::Node | String), separator : String) : Nodes
      nodes
        .map { |node| format(node) }
        .intersperse([separator] of Node)
        .flatten
    end

    def format(nodes : Array(Ast::Node | String)) : Nodes
      nodes.flat_map { |node| format(node) }
    end

    def format(node : T?, &block : T -> Nodes) forall T
      node.try(&block) || [] of Node
    end

    def format(node : Ast::Node) : Nodes
      [] of Node
    end

    def format(node : String) : Nodes
      [node] of Node
    end

    def format(node : Nil) : Nodes
      [] of Node
    end
  end
end
