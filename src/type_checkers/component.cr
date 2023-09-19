module Mint
  class TypeChecker
    # Check all nodes that were not checked before
    def check_all(node : Ast::Component) : Checkable
      resolve node

      resolve node.gets
      resolve node.constants
      resolve node.functions

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
        error! :component_main_properties do
          block do
            text "The"
            bold "Main"
            text "component cannot have properties because there is no way " \
                 "to pass values to them."
          end

          snippet "A property is defined here:", property
          snippet "The component in question is here:", node
        end
      end

      # Checking for ref conflicts
      node.refs.reduce({} of String => Ast::Node) do |memo, (variable, ref)|
        name = variable.value
        other = memo[name]?

        error! :component_reference_name_conflict do
          snippet "There are multiple references with the name:", name
          snippet "One reference is here:", variable
          snippet "The other reference is here:", other
        end if other

        memo[name] = variable
        memo
      end

      # Checking for style name conflicts
      node.styles.reduce({} of String => Ast::Node) do |memo, style|
        name = style.name.value
        other = memo[name]?

        error! :component_style_name_conflict do
          snippet "There are multiple styles with the name:", name
          snippet "One style is here:", style
          snippet "An other style is here:", other
        end if other

        memo[name] = style
        memo
      end

      # Checking for multiple connects to the same store
      node.connects.each do |connect|
        other = (node.connects - [connect]).find(&.store.value.==(connect.store.value))

        return error! :component_multiple_stores do
          block do
            text "The component is connected to the store"
            bold %("#{connect.store.value}")
            text "multiple times."
          end

          snippet "It is connected here:", other
          snippet "It is also connected here:", connect
        end if other
      end

      # Checking for conflict between exposed entity and own entity
      node.connects.each do |connect|
        connect.keys.each do |key|
          variable = key.target || key.name
          other = checked[variable.value]?

          error! :component_exposed_name_conflict do
            block do
              text "You cannot expose"
              bold %("#{variable.value}")
              text "from the store because the name is already taken."
            end

            snippet "The entity with the same name is here:", other
            snippet "The expose in question is here:", key
          end if other
        end
      end

      # Checking for multiple connects exposing the same value
      node.connects.reduce({} of String => Ast::Node) do |memo, connect|
        connect.keys.each do |key|
          variable = key.target || key.name
          other = memo[variable.value]?

          error! :component_multiple_exposed do
            block do
              text "The entity"
              bold %("#{variable.value}")
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

        error! :component_multiple_providers do
          block do
            text "You are subcribing to the provider"
            bold %("#{other.provider.value}")
            text "in a component multiple times."
          end

          snippet "A subscription is here:", other
          snippet "An other subscription is here:", use
        end if other
      end

      # Type checking the entities
      resolve node.connects
      resolve node.properties
      resolve node.states
      resolve node.uses

      error! :component_no_render_function do
        block do
          text "A component must have a"
          bold "render"
          text "function. This component does not have one:"
        end

        snippet node
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

          error! :component_render_function_mismatch do
            block do
              text "I was expecting the type of the"
              bold "render"
              text "function to match one of these types:"
            end

            snippet <<-PLAIN
              Function(Array(String))
              Function(Array(Html))
              Function(String)
              Function(Html)
              PLAIN

            snippet "Instead the type of the function is:", type.parameters.first
            snippet "The function in question is here:", function
          end unless matches
        when "componentDidMount",
             "componentDidUpdate",
             "componentWillUnmount"
          type =
            resolve function

          error! :component_lifecycle_function_mismatch do
            block do
              text "The type of the function"
              bold %("#{function.name.value}")
              text "of a component must be:"
            end

            snippet VOID_FUNCTION
            snippet "Instead it is:", type
            snippet "The function in question is here:", function
          end unless Comparer.compare(type, VOID_FUNCTION)
        end
      end

      VOID
    end
  end
end
