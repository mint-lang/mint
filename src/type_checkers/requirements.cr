module Mint
  class TypeChecker
    # Functions of a component which are part of the component itself (the
    # runtime calls them directly) instead of being functions on their own.
    LIFECYCLE_FUNCTIONS =
      %w[render componentDidMount componentDidUpdate componentWillUnmount]

    # A layer of values around a node: the node which provides them (a
    # `provide` or a component which provides values to its content) and the
    # types of the provided values by name.
    alias Layer = Tuple(Ast::Node, Hash(String, Checkable))

    # Why a unit needs a value: either it uses `with` directly, it references
    # a `with` member of its component, or it references an other unit which
    # needs it.
    alias Reason = Ast::WithItem | Tuple(Ast::Node, Ast::Node)

    # A value a unit needs: the type it is needed as and why it is needed.
    # A name can have different types on different paths, but only one in a
    # unit.
    record Need, type : Checkable, reason : Reason

    # A reference from a unit to an other: the referencing node and the layers
    # of values around it.
    record Edge,
      layers : Array(Layer),
      reference : Ast::Node,
      from : Ast::Node,
      to : Ast::Node

    # A function or get of a component accessed through a reference to the
    # component (`ref.function`): the access, the layers of values around it
    # and the accessed member.
    record RefSite,
      layers : Array(Layer),
      access : Ast::Node,
      member : Ast::Node

    # The chain of references from a node to the `with` which needs a value.
    record Trace,
      lines : Array(String),
      first : Ast::Node?,
      site : Ast::Node,
      item : Ast::WithItem

    alias Requirements = Hash(Ast::Node, Hash(String, Need))

    # The values components give to the content of their Html properties.
    @slots = {} of Ast::Property => Hash(String, Checkable)

    # Caches for the walks up the tree: the unit and layers around nodes,
    # the constants of components nodes are in, and the provided values
    # (types and names) of provides.
    @surroundings = {} of Ast::Node => Tuple(Ast::Node, Array(Layer))
    @component_constants = {} of Ast::Node => Ast::Constant?
    @provided_types = {} of Ast::Provide => Hash(String, Checkable)
    @provided_names = {} of Ast::Provide => Set(String)

    # Computes what values every unit (function, get, component) needs, what
    # values components provide to the content between their tags, and which
    # component members can use the values of the component directly.
    def check_requirements
      resolved =
        ->(node : Ast::Node) { cache.has_key?(node) }

      provides =
        ast.nodes.select(Ast::Provide).select(&resolved)

      # Pairs of provide nodes and names which are read by something.
      used =
        Set(Tuple(Ast::Node, String)).new

      check_slots(provides, used)

      requirements =
        Requirements.new

      # Gather the values which units use directly.
      ast.nodes.select(Ast::With).select(&resolved).each do |node|
        unit, layers =
          surroundings(node)

        node.items.each do |item|
          need(requirements, unit, layers, used, item.name.value,
            Need.new(cache[item], item))
        end
      end

      # A reference to a `with` member of a component is a `with` of its own
      # where it is written.
      variables.each do |node, (entity, _)|
        next unless entity.is_a?(Ast::WithItem)
        next unless entity.parent.is_a?(Ast::Component)
        next unless resolved.call(node)

        unit, layers =
          surroundings(node)

        need(requirements, unit, layers, used, entity.name.value,
          Need.new(cache[entity], {node, entity.as(Ast::Node)}))
      end

      # A reference to a `with` block inside a layer which provides the name
      # again means the new value (the innermost one), which must have the
      # type of the `with`.
      variables.each do |node, (entity, _)|
        next unless entity.is_a?(Ast::WithItem)
        next unless root = entity.parent
        next unless root.is_a?(Ast::With)
        next unless resolved.call(node)

        each_layer_until(node, root) do |layer|
          next unless layer[1].has_key?(entity.name.value)

          check_provided(requirements, layer, entity.name.value,
            Need.new(cache[entity], {node, entity.as(Ast::Node)}))

          used.add({layer[0], entity.name.value})
          break
        end
      end

      # Gather the references between units.
      edges = [] of Edge
      ref_sites = [] of RefSite

      variables.each do |node, (entity, _)|
        next unless resolved.call(node)
        next unless target = target_unit(entity)

        unit, layers =
          surroundings(node)

        edges << Edge.new(
          reference: node,
          layers: layers,
          from: unit,
          to: target)
      end

      ast.nodes.select(Ast::HtmlComponent).select(&resolved).each do |node|
        next unless component = node.component_node

        unit, layers =
          surroundings(node)

        edges << Edge.new(
          to: component.as(Ast::Node),
          reference: node,
          layers: layers,
          from: unit)
      end

      # Functions and gets accessed through a reference to a component
      # (`ref.function`) are bound to the values of the component.
      lookups.each do |node, (entity, component)|
        next unless node.is_a?(Ast::Variable)
        next unless (access = node.parent).is_a?(Ast::Access)
        next unless access.field == node
        next unless resolved.call(access)
        next unless component.is_a?(Ast::Component)
        next unless entity.is_a?(Ast::Function) || entity.is_a?(Ast::Get)

        ref_sites << RefSite.new(
          layers: surroundings(access)[1],
          access: access,
          member: entity)
      end

      # Propagate the needs until nothing changes. The values of members
      # accessed through a reference come from their component (not from
      # where the reference is used) so there are no layers for them here.
      propagated =
        edges + ref_sites.map do |site|
          Edge.new(
            from: site.member.parent.not_nil!,
            layers: [] of Layer,
            reference: site.access,
            to: site.member)
        end

      loop do
        changed = false

        propagated.each do |edge|
          next if edge.from == edge.to
          next unless target = requirements[edge.to]?

          target.each do |name, item|
            next if edge.layers.any?(&.[1].has_key?(name))

            changed = true if add_need(requirements, edge.from, name,
                                Need.new(item.type, {edge.reference, edge.to}))
          end
        end

        break unless changed
      end

      # Check the provided values which are given to references.
      edges.each do |edge|
        requirements[edge.to]?.try(&.each do |name, item|
          if layer = edge.layers.find(&.[1].has_key?(name))
            check_provided(requirements, layer, name,
              Need.new(item.type, {edge.reference, edge.to}))

            used.add({layer[0], name})
          end
        end)
      end

      # A value provided around a member accessed through a reference takes
      # precedence over the value of the component (it must have the type
      # the member needs it as). Only a layer around the access counts, so
      # what else the unit needs cannot change which value the member gets.
      ref_sites.each do |site|
        overrides = Set(String).new

        requirements[site.member]?.try(&.each do |name, item|
          next unless layer = site.layers.find(&.[1].has_key?(name))

          check_provided(requirements, layer, name,
            Need.new(item.type, {site.access, site.member}))

          used.add({layer[0], name})
          overrides.add(name)
        end)

        artifacts.overrides[site.access] = overrides
      end

      # Check that nothing is needed where nothing can provide values.
      requirements.each do |unit, items|
        next if items.empty?
        next unless entry_point?(unit)

        name, item =
          items.min_by(&.[0])

        not_provided(name, item.reason, requirements)
      end

      # Check that every provided value is read by something.
      provides.each do |node|
        node.fields.each do |field|
          next unless key = field.key
          next if used.includes?({node.as(Ast::Node), key.value})

          error! :provide_unused do
            block do
              text "The value"
              bold %("#{key.value}")
              text "is provided but nothing reads it."
            end

            snippet "The value in question is here:", field
          end
        end
      end

      requirements.each do |unit, items|
        next if items.empty?

        artifacts.requirements[unit] = items.keys.sort!
        artifacts.requirement_items[unit] =
          items.to_h do |name, item|
            {name, trace(name, item.reason, requirements).item}
          end
      end

      check_dependencies(requirements, edges)
      check_shortcuts(requirements, edges, ref_sites)
    end

    # Computes which values the constants of components depend on, so they
    # can be computed again when those values change. States are left out on
    # purpose: they belong to the component, so they only take their initial
    # value from the provided values and are not reset when those change.
    def check_dependencies(requirements : Requirements, edges : Array(Edge))
      dependencies =
        Hash(Ast::Node, Set(String)).new do |hash, key|
          hash[key] = Set(String).new
        end

      add =
        ->(node : Ast::Node, layers : Array(Layer), names : Array(String)) do
          return unless constant = component_constant(node)

          names.each do |name|
            next if layers.any?(&.[1].has_key?(name))
            dependencies[constant].add(name)
          end
        end

      ast.nodes.select(Ast::With).each do |node|
        next unless cache.has_key?(node)
        add.call(node, surroundings(node)[1], node.items.map(&.name.value))
      end

      variables.each do |node, (entity, _)|
        next unless entity.is_a?(Ast::WithItem)
        next unless entity.parent.is_a?(Ast::Component)
        next unless cache.has_key?(node)

        add.call(node, surroundings(node)[1], [entity.name.value])
      end

      edges.each do |edge|
        next unless needs = requirements[edge.to]?
        add.call(edge.reference, edge.layers, needs.keys)
      end

      # A member of the component (a constant, function or get) which uses
      # an other one depends on the values that one depends on, so constants
      # also follow values which reach them through functions and gets. The
      # values functions and gets need themselves are covered by the edges.
      references =
        variables.compact_map do |node, (entity, _)|
          next unless entity.is_a?(Ast::Constant) ||
                      entity.is_a?(Ast::Function) ||
                      entity.is_a?(Ast::Get)
          next unless entity.parent.is_a?(Ast::Component)
          next unless cache.has_key?(node)
          next unless member = component_member(node)
          next if member == entity

          {member, entity.as(Ast::Node)}
        end.uniq!

      loop do
        changed = false

        references.each do |(member, other)|
          next unless names = dependencies[other]?

          size = dependencies[member].size
          dependencies[member].concat(names)
          changed = true if dependencies[member].size != size
        end

        break unless changed
      end

      dependencies.each do |member, names|
        next unless member.is_a?(Ast::Constant)
        artifacts.dependencies[member] = names.to_a.sort! unless names.empty?
      end
    end

    # Returns the member of a component (a constant, or a function or get
    # which is not part of the component itself) the node is in, if any.
    def component_member(node : Ast::Node) : Ast::Node?
      component_constant(node) ||
        case unit = surroundings(node)[0]
        when Ast::Function, Ast::Get
          unit if unit.parent.is_a?(Ast::Component)
        end
    end

    # Returns the constant of a component the node is in, if any (the
    # result is cached for every node on the way up).
    def component_constant(node : Ast::Node) : Ast::Constant?
      path = [] of Ast::Node
      current = node
      result = nil

      while parent = current.parent
        path << current

        if parent.is_a?(Ast::Constant) && parent.parent.is_a?(Ast::Component)
          result = parent
          break
        end

        break if unit?(parent)

        if @component_constants.has_key?(parent)
          result = @component_constants[parent]
          break
        end

        current = parent
      end

      path.each { |item| @component_constants[item] = result }
      result
    end

    # Yields the layers of values around the node (innermost first) until
    # the root (an ancestor of it), using the cached walks from unit to unit.
    def each_layer_until(node : Ast::Node, root : Ast::Node, &)
      current = node

      loop do
        unit, layers =
          surroundings(current)

        layers.each do |layer|
          # A root which is not a unit (a `with`) can be below the unit.
          return unless inside?(layer[0], root)
          yield layer
        end

        return if unit == root || !inside?(unit, root) || unit.parent.nil?
        current = unit
      end
    end

    # Returns whether the node is the other or inside it.
    def inside?(node : Ast::Node, other : Ast::Node) : Bool
      node.file == other.file &&
        other.from.offset <= node.from.offset &&
        node.to.offset <= other.to.offset
    end

    # Records a value a unit uses directly: a layer around it provides it or
    # the unit needs it.
    def need(
      requirements : Requirements,
      unit : Ast::Node,
      layers : Array(Layer),
      used : Set(Tuple(Ast::Node, String)),
      name : String,
      need : Need,
    )
      if layer = layers.find(&.[1].has_key?(name))
        check_provided(requirements, layer, name, need)
        used.add({layer[0], name})
      else
        add_need(requirements, unit, name, need)
      end
    end

    # Adds a need to a unit, returns whether it was not needed before. A unit
    # cannot need a value as two different types.
    def add_need(requirements : Requirements, unit : Ast::Node, name : String, need : Need) : Bool
      items =
        (requirements[unit] ||= {} of String => Need)

      if existing = items[name]?
        unless Comparer.compare(existing.type, need.type)
          type_conflict(name, existing, need, requirements)
        end

        false
      else
        items[name] = need
        true
      end
    end

    # Checks that a provided value has the type it is needed as.
    def check_provided(requirements : Requirements, layer : Layer, name : String, need : Need)
      provided =
        layer[1][name]

      return if Comparer.compare(need.type, provided, expand: true)

      trace =
        trace(name, need.reason, requirements)

      source =
        layer_source(layer[0], name)

      error! :provide_type_mismatch do
        block do
          text "The provided value"
          bold %("#{name}")
          text "does not match the type it is needed as."
        end

        expected need.type, provided
        snippet "It is provided here:", source
        snippet "It is needed along this path:", trace.lines.join("\n")
        snippet "By this:", trace.site
      end
    end

    def type_conflict(name : String, first : Need, second : Need, requirements : Requirements)
      one =
        trace(name, first.reason, requirements)

      other =
        trace(name, second.reason, requirements)

      error! :with_type_conflict do
        block do
          text "The value"
          bold %("#{name}")
          text "is needed as two different types in the same place, so " \
               "nothing can provide it."
        end

        snippet "It is needed as this type:", first.type
        snippet one.lines.join("\n")
        snippet "And as this type:", second.type
        snippet other.lines.join("\n")
        snippet "The first is needed by this:", one.site
        snippet "The second is needed by this:", other.site
      end
    end

    # Determines which functions and gets of components can use the values of
    # the component directly instead of getting them as parameters: every
    # reference to them must get its values from the component itself.
    def check_shortcuts(requirements : Requirements, edges : Array(Edge), ref_sites : Array(RefSite))
      candidates =
        ast.components.each_with_object(Set(Ast::Node).new) do |component, memo|
          (component.functions + component.gets).each do |item|
            next unless needs = requirements[item]?
            next if needs.empty?
            next unless target_unit(item) == item

            component_needs =
              requirements[component]? || {} of String => Need

            memo.add(item) if needs.all? do |name, need|
                                component_needs[name]?.try do |other|
                                  Comparer.compare(other.type, need.type)
                                end
                              end
          end
        end

      ref_sites.each { |site| candidates.delete(site.member) }

      loop do
        removed =
          edges.select do |edge|
            next false unless edge.to.in?(candidates)

            component = edge.to.parent
            needs = requirements[edge.to]

            !(edge.from == component || (edge.from.in?(candidates) && edge.from.parent == component)) ||
              edge.layers.any? { |layer| needs.keys.any? { |name| layer[1].has_key?(name) } }
          end

        break if removed.empty?
        removed.each { |edge| candidates.delete(edge.to) }
      end

      artifacts.shortcuts.concat(candidates)
    end

    # Computes for every Html property of every component the values the
    # component provides around every use of it: first the names, then their
    # types (which must be the same around every use).
    def check_slots(provides : Array(Ast::Provide), used : Set(Tuple(Ast::Node, String)))
      universe =
        provides.flat_map(&.names).to_set

      uses =
        Hash(Ast::Property, Array(Ast::Node)).new do |hash, key|
          hash[key] = [] of Ast::Node
        end

      names = {} of Ast::Property => Set(String)

      ast.components.each do |component|
        next unless cache.has_key?(component)
        next if component.in?(exported)

        component.properties.each do |property|
          next unless html_property?(property)
          names[property] = Set(String).new
        end
      end

      variables.each do |node, (entity, parent)|
        next unless entity.is_a?(Ast::Property)
        next unless names.has_key?(entity)
        next unless parent == entity.parent

        uses[entity] << node
      end

      uses.each_key { |property| names[property] = universe.dup }

      # The nodes which may give values to each use (innermost first). They
      # don't change, so they are computed once.
      walks =
        uses.to_h do |property, nodes|
          {property, nodes.map { |node| {node, layer_nodes_in(node, property.parent.not_nil!)} }}
        end

      # The names: the ones every use of the property is covered by.
      loop do
        changed = false

        walks.each do |property, items|
          current =
            items.reduce(universe.dup) do |memo, (_, walk)|
              covered =
                walk.each_with_object(Set(String).new) do |item, set|
                  set.concat(layer_names(item, names))
                end

              memo & covered
            end

          next if current == names[property]

          names[property] = current
          changed = true
        end

        break unless changed
      end

      # The types: from the innermost layer which covers each name.
      types =
        names.transform_values { {} of String => Checkable }

      loop do
        changed = false

        walks.each do |property, items|
          names[property].each do |name|
            next if types[property].has_key?(name)

            items.each do |(_, walk)|
              next unless layer = innermost(walk, name, names)
              next unless type = layer_type(layer, name, types)

              types[property][name] = type
              changed = true
              break
            end
          end
        end

        break unless changed
      end

      # Every use must get the same type for a name.
      walks.each do |property, items|
        names[property].each do |name|
          next unless type = types[property][name]?

          items.each do |(node, walk)|
            next unless layer = innermost(walk, name, names)

            other =
              layer_type(layer, name, types)

            error! :with_type_conflict do
              block do
                text "The value"
                bold %("#{name}")
                text "is given to the uses of the property"
                bold %("#{property.name.value}")
                text "as different types, so its content cannot need it."
              end

              snippet "One use gets this type:", type
              snippet "This use gets this type:", other || VOID
              snippet "The use in question is here:", node
            end unless other && Comparer.compare(type, other)

            used.add({layer, name}) if layer.is_a?(Ast::Provide)
          end
        end
      end

      @slots =
        types.reject { |_, items| items.empty? }

      # The layers around nodes depend on the slots.
      @surroundings.clear

      @slots.each do |property, items|
        artifacts.slots[property] = items.keys.sort!
      end
    end

    # Returns whether the property holds content between the tags of a
    # component (`Html` or `Array(Html)`).
    def html_property?(property : Ast::Property) : Bool
      case type = cache[property]?
      when Type
        type.name == "Html" ||
          (type.name == "Array" && type.parameters.first?.try(&.name) == "Html")
      else
        false
      end
    end

    # Returns the nodes which may give values to the node (innermost first)
    # until the given root.
    def layer_nodes_in(node : Ast::Node, root : Ast::Node) : Array(Ast::Node)
      result = [] of Ast::Node
      previous = node

      while (current = previous.parent) && previous != root
        result << current if gives_values?(current, previous)
        previous = current
      end

      result
    end

    # Returns whether the node gives values to its child: the body of a
    # `provide`, the content of a component or the value of an attribute of
    # a component.
    def gives_values?(node : Ast::Node, child : Ast::Node) : Bool
      case node
      when Ast::Provide
        child == node.body
      when Ast::HtmlComponent
        child.in?(node.children)
      when Ast::HtmlAttribute
        child == node.value && slot_property(node).is_a?(Ast::Property)
      else
        false
      end
    end

    # Returns the property of a component which a node gives content to.
    def slot_property(node : Ast::Node) : Ast::Property?
      case node
      when Ast::HtmlComponent
        node.component_node.try(&.properties.find(&.name.value.==("children")))
      when Ast::HtmlAttribute
        case property = lookups[node]?.try(&.[0])
        when Ast::Property
          property
        end
      end
    end

    # Returns the names a node gives to its child (using the slot names).
    def layer_names(node : Ast::Node, names : Hash(Ast::Property, Set(String))) : Set(String)
      case node
      when Ast::Provide
        @provided_names[node] ||= node.names.to_set
      else
        slot_property(node).try { |property| names[property]? } || Set(String).new
      end
    end

    # Returns the innermost node which gives the named value from the nodes
    # which may give values to a node (innermost first).
    def innermost(walk : Array(Ast::Node), name : String, names) : Ast::Node?
      walk.find do |item|
        layer_names(item, names).includes?(name)
      end
    end

    # Returns the node to show in errors for a node which gives a named
    # value: the field of a `provide` or the tag of a component.
    def layer_source(node : Ast::Node, name : String) : Ast::Node
      case node
      when Ast::Provide
        node.fields.find(&.key.try(&.value.==(name))) || node
      when Ast::HtmlComponent
        node.component
      else
        node
      end
    end

    # Returns the type of the named value a node gives, if it is known.
    def layer_type(node : Ast::Node, name : String, types : Hash(Ast::Property, Hash(String, Checkable))) : Checkable?
      case node
      when Ast::Provide
        node.fields.find(&.key.try(&.value.==(name))).try { |field| cache[field.value]? }
      else
        slot_property(node).try { |property| types[property]?.try(&.[name]?) }
      end
    end

    # Returns the unit the node belongs to and the layers of values around it
    # (the innermost first). The result is cached for every node on the way
    # up, so walks from nodes next to each other share their work.
    def surroundings(node : Ast::Node) : Tuple(Ast::Node, Array(Layer))
      if cached = @surroundings[node]?
        return cached
      end

      # The nodes on the way up which are not known yet (innermost first).
      path = [] of Ast::Node
      current = node

      loop do
        path << current

        unless parent = current.parent
          # The topmost node: it is its own unit.
          @surroundings[path.pop] = {current, [] of Layer}
          break
        end

        if unit?(parent)
          layers =
            layer(parent, current).try { |item| [item] } || [] of Layer

          @surroundings[path.pop] = {parent, layers}
          break
        end

        break if @surroundings.has_key?(parent)
        current = parent
      end

      # Every node gets the unit of its parent and its layers (with the
      # layer its parent gives it, if any).
      path.reverse_each do |item|
        parent = item.parent.not_nil!
        unit, layers = @surroundings[parent]

        @surroundings[item] =
          if layer = layer(parent, item)
            {unit, [layer] + layers}
          else
            {unit, layers}
          end
      end

      @surroundings[node]
    end

    # Returns the layer of values a node gives to one of its children.
    def layer(node : Ast::Node, child : Ast::Node) : Layer?
      return unless gives_values?(node, child)

      case node
      when Ast::Provide
        types =
          @provided_types[node] ||=
            node.fields.each_with_object({} of String => Checkable) do |field, memo|
              next unless key = field.key
              next unless type = cache[field.value]?
              memo[key.value] = type
            end

        {node.as(Ast::Node), types}
      else
        slot_property(node)
          .try { |property| @slots[property]? }
          .try { |types| {node, types} }
      end
    end

    # Returns whether the node is a unit: something that has its own needs.
    def unit?(node : Ast::Node) : Bool
      case node
      when Ast::Function
        !lifecycle_function?(node)
      when Ast::Constant, Ast::State
        !node.parent.is_a?(Ast::Component)
      when Ast::Component,
           Ast::Signal,
           Ast::Route,
           Ast::Defer,
           Ast::Test,
           Ast::Get
        true
      else
        false
      end
    end

    def lifecycle_function?(node : Ast::Function) : Bool
      node.parent.is_a?(Ast::Component) &&
        node.name.value.in?(LIFECYCLE_FUNCTIONS)
    end

    # Returns the unit of the referenced entity if it is a function or a get.
    def target_unit(entity : Ast::Node) : Ast::Node?
      case entity
      when Ast::Function
        if lifecycle_function?(entity)
          entity.parent
        else
          entity
        end
      when Ast::Get
        entity
      end
    end

    # Returns whether nothing can pass values to the unit.
    def entry_point?(node : Ast::Node) : Bool
      case node
      when Ast::Component
        node.name.value == "Main" || node.global? || node.in?(exported)
      when Ast::Function
        node.in?(exported) ||
          (node.parent.is_a?(Ast::Provider) && node.name.value == "update")
      when Ast::Get
        false
      else
        true
      end
    end

    # Follows the reasons of a need down to the `with` which needs the value.
    def trace(name : String, reason : Reason, requirements : Requirements) : Trace
      lines = [] of String

      # The reference which starts the chain: the outermost place where the
      # value could be provided.
      first = nil

      # The node which needs the value: a `with` or a reference to a `with`
      # member of a component.
      site, item =
        case reason
        in Ast::WithItem
          lines << owner_label(reason)
          {reason.as(Ast::Node), reason}
        in Tuple(Ast::Node, Ast::Node)
          lines << owner_label(reason[0])
          first = reason[0]

          while reason.is_a?(Tuple(Ast::Node, Ast::Node)) &&
                !reason[1].is_a?(Ast::WithItem)
            lines << "→ #{unit_label(reason[1])} (#{location(reason[0])})"
            reason = requirements[reason[1]][name].reason
          end

          case reason
          in Ast::WithItem
            {reason.as(Ast::Node), reason}
          in Tuple(Ast::Node, Ast::Node)
            {reason[0], reason[1].as(Ast::WithItem)}
          end
        end

      lines << "→ with #{item.name.value} : #{formatter.format!(item.type)} (#{location(site)})"

      Trace.new(lines: lines, first: first, site: site, item: item)
    end

    def not_provided(name : String, reason : Reason, requirements : Requirements)
      trace =
        trace(name, reason, requirements)

      error! :with_not_provided do
        block do
          text "The value"
          bold %("#{name}")
          text "is needed here but nothing provides it:"
        end

        snippet trace.lines.join("\n")

        if (first = trace.first) && first != trace.site
          snippet "Provide it around this (or further up):", first
        end

        snippet "The value is needed by this:", trace.site
      end
    end

    # Returns the location of a node as shown in snippets.
    def location(node : Ast::Node) : String
      "#{node.file.relative_path_posix}:#{node.from.line}:#{node.from.column + 1}"
    end

    # Returns a label for the entity containing the node.
    def owner_label(node : Ast::Node) : String
      current = node

      while current
        case current
        when Ast::Function, Ast::Get, Ast::Constant, Ast::State, Ast::Signal,
             Ast::Component, Ast::Test, Ast::Route
          return unit_label(current)
        end

        current = current.parent
      end

      "?"
    end

    # Returns a label for a unit.
    def unit_label(node : Ast::Node) : String
      case node
      when Ast::Component
        "<#{node.name.value}/>"
      when Ast::Function, Ast::Get, Ast::Constant, Ast::State, Ast::Signal
        case parent = node.parent
        when Ast::Component, Ast::Module, Ast::Store, Ast::Provider
          "#{parent.name.value}.#{node.name.value}"
        else
          node.name.value
        end
      when Ast::Test
        "test #{formatter.format!(node.name)}"
      when Ast::Route
        %(route "#{node.url}")
      else
        node.class.name.split("::").last
      end
    end
  end
end
