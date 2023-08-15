module Mint
  class TypeChecker
    def static_type_signature(node : Ast::Component)
      fields = {} of String => Checkable

      node.gets.each do |item|
        fields[item.name.value] = static_type_signature(item)
      end

      node.functions.each do |item|
        fields[item.name.value] = static_type_signature(item)
      end

      node.properties.each do |item|
        fields[item.name.value] = static_type_signature(item)
      end

      node.states.each do |item|
        fields[item.name.value] = static_type_signature(item)
      end

      node.refs.each do |variable, ref|
        case ref
        when Ast::Component
          fields[variable.value] =
            Type.new("Maybe", [static_type_signature(ref)] of Checkable)
        when Ast::HtmlElement
          fields[variable.value] =
            Type.new("Maybe", [static_type_signature(ref)] of Checkable)
        end
      end

      Record.new(node.name.value, fields)
    end

    # Check all nodes that were not checked before
    def check_all(node : Ast::Component) : Checkable
      resolve node

      scope node do
        resolve node.gets
        resolve node.functions
      end

      VOID
    end

    def check(node : Ast::Component) : Checkable
      # Checking for global naming conflict
      check_global_names node.name.value, node

      # Checking for naming conflicts
      checked =
        {} of String => Ast::Node

      check_names(node.properties, "component", checked)
      check_names(node.functions, "component", checked)
      check_names(node.states, "component", checked)
      check_names(node.gets, "component", checked)

      # Checking for properties in Main
      if node.name.value == "Main" && (property = node.properties.first?)
        error :component_main_properties do
          block do
            text "The"
            bold "Main"
            text "component cannot have properties."
          end

          snippet "A property is defined here:", property
          snippet "The component is here:", node
        end
      end

      # Checking for ref conflicts
      node.refs.reduce({} of String => Ast::Node) do |memo, (variable, ref)|
        name = variable.value
        other = memo[name]?

        error :component_reference_name_conflict do
          block do
            text "There are multiple references with the name:"
            bold "#{name}."
          end

          snippet "One reference is here:", node
          snippet "An other reference is here:", other
        end if other

        memo[name] = ref
        memo
      end

      # Checking for style name conflicts
      node.styles.reduce({} of String => Ast::Node) do |memo, style|
        name = style.name.value
        other = memo[name]?

        error :component_style_name_conflict do
          block do
            text "There are multiple style definitions with the name:"
            bold "#{name}."
          end

          snippet "One definition is here:", node
          snippet "An other definition is here:", other
        end if other

        memo[name] = style
        memo
      end

      # Checking for multiple connects to the same store
      node.connects.each do |connect|
        other = (node.connects - [connect]).find(&.store.value.==(connect.store.value))

        return error :component_multiple_stores do
          block do
            text "The component is connected to the store"
            bold connect.store.value
            text "multiple times."
          end

          snippet "It is connected here:", other
          snippet "It is also connected here:", connect
        end if other
      end

      # Checking for conflict between exposed entity and own entity
      node.connects.each do |connect|
        connect.keys.each do |key|
          variable = key.name || key.variable
          other = checked[variable.value]?

          error :component_exposed_name_conflict do
            block do
              text "You cannot expose"
              bold variable.value
              text "from the store because the name is already taken."
            end

            snippet "The entity with the same name is here:", other
            snippet key
          end if other
        end
      end

      # Checking for multiple connects exposing the same value
      node.connects.reduce({} of String => Ast::Node) do |memo, connect|
        connect.keys.each do |key|
          variable = key.name || key.variable
          other = memo[variable.value]?

          error :component_multiple_exposed do
            block do
              text "The function or property"
              bold variable.value
              text "from a store is exposed multiple times."
            end

            snippet "It is exposed here:", other
            snippet "It is also exposed here:", key
          end if other

          memo[variable.value] = key
        end
        memo
      end

      # Checking for multiple same uses of the same provider
      node.uses.each do |use|
        other = (node.uses - [use]).find(&.provider.value.==(use.provider.value))

        error :component_multiple_providers do
          block do
            text "You are subcribing to the provider"
            bold other.provider.value
            text "multiple times."
          end

          snippet "A subscription is here:", other
          snippet "An other subscription is here:", node
        end if other
      end

      # Type checking the entities
      scope node do
        resolve node.connects
        resolve node.properties
        resolve node.states
        resolve node.uses

        error :component_no_render_function do
          block do
            text "A component must have a"
            bold "render"
            text "function."
          end

          snippet "This component does not have one:", node
        end unless node.functions.any?(&.name.value.==("render"))

        node.functions.each do |function|
          case function.name.value
          when "render"
            type =
              resolve function

            matches =
              [HTML, STRING, HTML_CHILDREN, TEXT_CHILDREN].any? do |item|
                Comparer.compare(type, Type.new("Function", [item] of Checkable))
              end

            error :component_render_function_mismatch do
              block do
                text "I was expecting the type of the"
                bold "render"
                text "function to match one of these types:"
              end

              snippet "Function(Html), Function(String), Function(Array(String)), Function(Array(Html))"
              snippet "The type of the function is:", type.parameters.first
              snippet "The render function is here:", function
            end unless matches
          when "componentDidMount",
               "componentDidUpdate",
               "componentWillUnmount"
            type =
              resolve function

            error :component_lifecycle_function_mismatch do
              block do
                text "The type of the function"
                bold function.name.value
                text "of a component must be:"
              end

              snippet VOID_FUNCTION
              snippet "Instead it is:", type
              snippet "The function is here:", function
            end unless Comparer.compare(type, VOID_FUNCTION)
          end
        end
      end

      VOID
    end
  end
end
