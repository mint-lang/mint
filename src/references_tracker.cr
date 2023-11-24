module Mint
  class ReferencesTracker
    class Node
      property parent : Node?
      getter node : Ast::Node

      def initialize(@parent, @node)
      end
    end

    alias Bundles = Hash(Ast::Node | Bundle, Set(Ast::Node))
    alias Bundle = Compiler2::Bundle

    # This hash contains which nodes belong to which bundle.
    getter bundles = Bundles.new

    # This hash contains the final mapping of which
    # bundle contains which node (inverse of bundles).
    @mapping = {} of Ast::Node => Ast::Node | Bundle

    # This tracks what nodes links to the key node..
    @parents = {} of Ast::Node => Set(Ast::Node)

    # This is a map for looking up nodes from AST nodes.
    @node_map = {} of Ast::Node => Node

    # This contains all the nodes.
    @nodes = [] of Node

    def keep?(node)
      case node
      when Ast::TypeDefinition,
           Ast::HtmlComponent,
           Ast::Component,
           Ast::Constant,
           Ast::Property,
           Ast::Function,
           Ast::Provider,
           Ast::Module,
           Ast::Encode,
           Ast::Decode,
           Ast::Defer,
           Ast::State,
           Ast::Store,
           Ast::Get
        true
      end
    end

    def collapse
      @nodes.each do |node|
        if keep?(node.node)
          parent =
            node.parent

          while parent && !keep?(parent.node)
            parent = parent.parent
          end

          if parent
            @parents[parent.node] ||= Set(Ast::Node).new
            @parents[parent.node].add(node.node)
          end

          node.parent = parent
        end
      end

      @nodes.select! { |node| keep?(node.node) }
    end

    # Adds a dependency link (node depends on target).
    def add(node, target)
      parent =
        @node_map[node] ||= Node.new(nil, node)

      @nodes << (@node_map[target] = Node.new(parent, target))
    end

    # Returns the bundle of the node.
    def bundle_of(node : Ast::Node) : Ast::Node | Bundle
      @mapping[node]? || Bundle::Index
    end

    # Calculates which node belongs to which bundle.
    def calculate(nodes : Set(Ast::Node)) : Bundles
      # Collapse links, removing not needed ones an repointing.
      collapse

      # These will be the bundles, plus the index.
      target_bundles =
        nodes.select(Ast::Component).select(&.async?) +
          nodes.select(Ast::Defer)

      # Get the bundles of the top-level entities.
      bundles =
        calculate

      # All the nodes that needs to be in a bundle.
      target_nodes =
        bundles
          .values
          .flat_map(&.to_a)

      # We gather all the nodes which are used more than once.
      multi_uses =
        target_nodes
          .tally({} of Ast::Node => Int32)
          .select { |_, count| count >= 2 }
          .keys
          .to_set

      # Remove the multi used nodes from the bundles.
      bundles.transform_values! { |dependencies| dependencies - multi_uses }

      # Find all the nodes which are not in a target bundle.
      not_bundled =
        bundles
          .reject { |key, _| target_bundles.includes?(key) }
          .values
          .flat_map(&.to_a)
          .to_set

      # The index bundle is the differenc of all the nodes and
      # the nodes which are only used by one bundle.
      index_bundle =
        (nodes - (target_nodes.to_set - multi_uses)) + not_bundled

      # We put together the final bundles.
      bundles
        .select { |key, _| target_bundles.includes?(key) }
        .tap(&.[]=(Bundle::Index, index_bundle))
        .tap(&.each do |bundle, dependencies|
          dependencies.each { |node| @mapping[node] = bundle }
          @bundles[bundle] = dependencies
        end)
    end

    # We go through each top-level entity and calculate their dependencies.
    private def calculate : Bundles
      @node_map
        .keys
        .each_with_object(Bundles.new) do |node, sets|
          case node
          when Ast::TypeDefinition,
               Ast::Component,
               Ast::Provider,
               Ast::Module,
               Ast::Routes,
               Ast::Locale,
               Ast::Store,
               Ast::Suite,
               Ast::Defer
            sets[node] = calculate node: node, base: node
          end
        end
    end

    private def calculate(
      *,
      dependencies = Set(Ast::Node).new,
      node : Ast::Node,
      base : Ast::Node,
      level = 0
    ) : Set(Ast::Node)
      dependencies.add(node)

      @parents[node]?.try(&.each do |item|
        next if item.is_a?(Ast::Defer) || item.is_a?(Ast::TypeDefinition)
        next if item.is_a?(Ast::Component) && item.async?
        next if item.is_a?(Ast::Property) && item.parent != base

        dependencies.add(item)

        calculate(
          dependencies: dependencies,
          level: level + 1,
          node: item,
          base: base)
      end)

      dependencies
    end

    def print_bundle_tree(io)
      bundles.each do |node, dependencies|
        dependencies.each do |item|
          io.puts "#{Debugger.dbg(node)} ➔ #{Debugger.dbg(item)}"
        end
      end
    end

    def print_dependency_tree(node, level = 0, io = IO::Memory.new)
      if level.zero?
        io.puts Debugger.dbg(node)
      else
        io.puts "➔ #{Debugger.dbg(node)}".indent(level * 2)
      end

      @nodes
        .select(&.parent.try(&.node.==(node)))
        .each { |item| print_dependency_tree(item.node, level + 1, io) }
    end
  end
end
