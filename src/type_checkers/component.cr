module Mint
  class TypeChecker
    type_error ComponentFunctionTypeMismatch
    type_error ComponentExposedNameConflict
    type_error ComponentRenderTypeMismatch
    type_error ComponentEntityNameConflict
    type_error ComponentStateNameConflict
    type_error ComponentStyleNameConflict
    type_error ComponentMultipleConnects
    type_error ComponentMultipleExposed
    type_error ComponentNotFoundRender
    type_error ComponentMultipleUses

    # Check all nodes that were not checked before
    def check_all(node : Ast::Component) : Checkable
      resolve node

      scope node do
        resolve node.gets
        resolve node.functions
      end

      NEVER
    end

    def check(node : Ast::Component) : Checkable
      # Checking for global naming conflict
      check_global_names node.name, node

      # Checking for naming conflicts
      checked =
        {} of String => Ast::Node

      check_names(node.properties, ComponentEntityNameConflict, checked)
      check_names(node.functions, ComponentEntityNameConflict, checked)
      check_names(node.states, ComponentStateNameConflict, checked)
      check_names(node.gets, ComponentEntityNameConflict, checked)

      # Checking for style name conflicts
      node.styles.reduce({} of String => Ast::Node) do |memo, style|
        name = style.name.value

        if other = memo[name]?
          raise ComponentStyleNameConflict, {
            "node"  => style,
            "other" => other,
            "name"  => name,
          }
        end

        memo[name] = style
        memo
      end

      # Checking for multiple connects to the same store
      node.connects.each do |connect|
        other = (node.connects - [connect]).find(&.store.==(connect.store))

        raise ComponentMultipleConnects, {
          "name"  => connect.store,
          "node"  => connect,
          "other" => other,
        } if other
      end

      # Checking for conflict between exposed entity and own entity
      node.connects.each do |connect|
        connect.keys.each do |key|
          variable = key.name || key.variable
          other = checked[variable.value]?

          raise ComponentExposedNameConflict, {
            "name"  => variable.value,
            "other" => other,
            "node"  => key,
          } if other
        end
      end

      # Checking for multiple connects exposing the same value
      node.connects.reduce({} of String => Ast::Node) do |memo, connect|
        connect.keys.each do |key|
          variable = key.name || key.variable
          other = memo[variable.value]?

          raise ComponentMultipleExposed, {
            "name"  => variable.value,
            "other" => other,
            "node"  => key,
          } if other

          memo[variable.value] = key
        end
        memo
      end

      # Checking for multiple same uses of the same provider
      node.uses.each do |use|
        other = (node.uses - [use]).find(&.provider.==(use.provider))

        raise ComponentMultipleUses, {
          "name"  => use.provider,
          "other" => other,
          "node"  => use,
        } if other
      end

      # Type checking the entities
      scope node do
        resolve node.connects
        resolve node.properties
        resolve node.states
        resolve node.uses

        raise ComponentNotFoundRender, {
          "node" => node,
        } unless node.functions.any?(&.name.value.==("render"))

        node.functions.each do |function|
          case function.name.value
          when "render"
            type =
              resolve function

            matches =
              [HTML, STRING, HTML_CHILDREN, TEXT_CHILDREN].any? do |item|
                Comparer.compare(type, Type.new("Function", [item] of Checkable))
              end

            raise ComponentRenderTypeMismatch, {
              "node" => function,
              "got"  => type.parameters.first,
            } unless matches
          when "componentDidMount",
               "componentDidUpdate",
               "componentWillUnmount"
            type =
              resolve function

            raise ComponentFunctionTypeMismatch, {
              "name"     => function.name.value,
              "expected" => VOID_FUNCTION,
              "node"     => function,
              "got"      => type,
            } unless Comparer.compare(type, VOID_FUNCTION)
          end
        end
      end

      NEVER
    end
  end
end
