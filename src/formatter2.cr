module Mint
  class Formatter2
    class Config
      property indent_size : Int32

      def initialize(@indent_size = 2)
      end
    end

    alias Node = String | Symbol | Indent | Group
    alias Nodes = Array(Node)

    record Indent, items : Nodes

    enum Behavior
      BreakNotFits
      BreakAll
      Block
    end

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
    record Group,
      ends : Tuple(String, String),
      items : Array(Nodes),
      behavior : Behavior = Behavior::BreakAll,
      separator : String = "",
      pad : Bool = false

    record List,
      items : Array(Nodes),
      separator : String? = nil

    getter config : Config

    def initialize(@config = Config.new)
    end

    def group(
      *,
      ends : Tuple(String, String),
      items : Array(Ast::Node),
      behavior : Behavior = Behavior::BreakAll,
      separator : String = "",
      pad : Bool = false
    )
      [
        Group.new(
          items: items.map(&->format(Ast::Node)),
          separator: separator,
          behavior: behavior,
          ends: ends,
          pad: pad),
      ] of Node
    end

    def format_arguments(nodes : Array(Ast::Node)) : Nodes
      return [] of Node if nodes.empty?

      [Group.new(
        items: nodes.map(&->format(Ast::Node)),
        ends: {"(", ")"},
        separator: ",")] of Node
    end

    def documentation_comment(node : Ast::Comment?) : Nodes
      node.try { |item| format(item) + [:ln] } || [] of Node
    end

    def format(node : Ast::Node?, &block : Ast::Node -> Nodes)
      node.try(&block) || [] of Node
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

    def format(node : Ast::Node) : Nodes
      puts "Formatter not implemented for node '#{node}' (this should not happen!)"
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
