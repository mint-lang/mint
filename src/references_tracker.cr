module Mint
  # This class tracks links between nodes which gets populated during
  # type checking.
  #
  # A link is stored as a tuple {node, parent} where node depends on the
  # parent. Eventually this forms a graph, which from we can decide what
  # bundles to construct. To do that we track back each node to it's root
  # node(s) through the links.
  #
  # Async components and deferred code got their on bundles
  # and any other code which is referenced from multiple sources will
  # get their own bundle.
  class ReferencesTracker
    alias Bundle = Set(Ast::Node) | Compiler::Bundle
    alias Nodes = Set(Ast::Node)

    class Link
      property parent : Ast::Node
      property node : Ast::Node

      def initialize(@node, @parent)
      end
    end

    # A cache for the root lookups.
    @cache = {} of Ast::Node => Set(Ast::Node)

    # A set to save the links to.
    @links = Set(Link).new

    def link(node, parent)
      @links.add(Link.new(node: node, parent: parent))
    end

    def add(node, parent)
      return unless parent

      case node
      when Ast::Property
        link(node, node.parent.not_nil!)
      when Ast::Component
        link(node, parent) unless node.async?
      when Ast::Defer
        # We link this to itself so it can be a bundle later.
        link(node, node)
      else
        link(node, parent)
      end
    end

    def replace(node, other)
      @links.each do |link|
        next unless link.node == node
        link.node = other
      end
    end

    def bundle?(nodes : Nodes)
      nodes.all?(&->bundle?(Ast::Node))
    end

    def bundle?(node : Ast::Node)
      case node
      when Ast::Component
        node.async?
      when Ast::Defer
        true
      else
        false
      end
    end

    # This method determines the roots of the node.
    def roots(node : Ast::Node) : Nodes
      roots(node, {} of Ast::Node => Int32).first
    end

    # This method recursively determines the roots of the node.
    #
    # The links can contain cycles (merging identical tags in `replace` can
    # create one), so we track the nodes we are visiting (with their depth)
    # and don't follow links back to them. Besides the roots, the lowest
    # depth of the skipped nodes is returned, if that is above the node then
    # its roots are not complete (the rest is collected by that node) so we
    # can't cache them.
    private def roots(
      node : Ast::Node,
      visiting : Hash(Ast::Node, Int32),
    ) : Tuple(Nodes, Int32)
      if cached = @cache[node]?
        return {cached, Int32::MAX}
      end

      if depth = visiting[node]?
        return {Nodes.new, depth}
      end

      # If the node is a bundle in itself we just return it.
      return {@cache[node] = Nodes{node}, Int32::MAX} if bundle?(node)

      # Select all the links for the node.
      links =
        @links.select { |item| item.node == node }

      # If there are none that means we reached the root of the tree.
      return {@cache[node] = Nodes{node}, Int32::MAX} if links.empty?

      # Otherwise return all roots of the parent nodes.
      depth =
        visiting[node] = visiting.size

      lowest =
        Int32::MAX

      result =
        links.each_with_object(Nodes.new) do |item, memo|
          parents, skipped =
            roots(item.parent, visiting)

          lowest = Math.min(lowest, skipped)
          memo.concat(parents)
        end

      visiting.delete(node)

      @cache[node] = result if lowest >= depth

      {result, lowest}
    end

    # This method calculates bundles from the links.
    def calculate : Hash(Bundle, Nodes)
      @links
        .each_with_object({} of Ast::Node => Nodes) do |node, memo|
          memo[node.node] ||= Nodes.new
          memo[node.node].concat(roots(node.parent))
        end
        .each_with_object({} of Bundle => Nodes) do |(node, parents), memo|
          # NOTE: For debugging purposes.
          # puts "#{Debugger.dbg(node)} ---> #{parents.map { |item| Debugger.dbg(item) }}"

          bundle =
            if bundle?(parents)
              parents
            else
              Compiler::Bundle::Index
            end

          memo[bundle] ||= Nodes.new
          memo[bundle] << node

          # We need to add the defer or component to it's own bundle.
          memo[bundle].concat(parents) if parents.size == 1
        end
    end
  end
end
