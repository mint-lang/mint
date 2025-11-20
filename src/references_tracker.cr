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

    # A set to save the links to.
    @links = Set(NamedTuple(node: Ast::Node, parent: Ast::Node)).new

    # A cache for the root lookups.
    @cache = {} of Ast::Node => Set(Ast::Node)

    def link(node, parent)
      @links.add({node: node, parent: parent})
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

    # This method recursively determines the roots of the node.
    def roots(node : Ast::Node) : Nodes
      @cache[node] ||= begin
        # If the node is a bundle in itself  we just return it.
        if bundle?(node)
          [node] of Ast::Node
        else
          # Select all the links for the node.
          links =
            @links.select { |item| item[:node] == node }

          # If there are none that means we reached the root of the tree,
          # otherwise return all roots of the parent nodes.
          if links.empty?
            [node]
          else
            links.flat_map { |item| roots(item[:parent]).to_a }
          end
        end.to_set
      end
    end

    # This method calculates bundles from the links.
    def calculate : Hash(Bundle, Nodes)
      @links
        .each_with_object({} of Ast::Node => Nodes) do |node, memo|
          memo[node[:node]] ||= Nodes.new
          memo[node[:node]].concat(roots(node[:parent]))
        end
        .each_with_object({} of Bundle => Nodes) do |(node, parents), memo|
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
