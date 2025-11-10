module Mint
  class TypeChecker
    # This file contains the logic for destructuring (aka pattern matching).
    # It's a recursive algorithm, traversing the destructuring tree and the
    # type tree simultaneously.
    #
    # - if one of the destructurings is a mismatch it errors out
    # - non destructuring nodes are resolved and compared with condition

    # An alias for the variable scope (of Mint::Typechecker::Scope)
    alias VariableScope = Tuple(String, Checkable, Ast::Node)

    def destructuring_type_mismatch(expected : Checkable, got : Checkable, node : Ast::Node)
      error! :destructuring_type_mismatch do
        block "A value does not match its supposed type in a destructuring."
        expected expected, got
        snippet "The destructuring in question is here:", node
      end
    end

    def destructure(
      node : Nil,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope,
    )
      variables
    end

    def destructure(
      node : Ast::Discard,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope,
    )
      variables
    end

    def destructure(
      node : Ast::Node,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope,
    )
      type =
        resolve(node)

      destructuring_type_mismatch(
        expected: condition,
        node: node,
        got: type) unless Comparer.compare(type, condition)

      variables
    end

    # This is for the `let` statement when it's a single assignment
    def destructure(
      node : Ast::Variable,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope,
    )
      cache[node] = condition
      variables.tap(&.push({node.value, condition, node}))
    end

    def destructure(
      node : Ast::ArrayDestructuring,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope,
    )
      destructuring_type_mismatch(
        expected: ARRAY,
        got: condition,
        node: node,
      ) unless Comparer.compare(ARRAY, condition)

      spreads =
        node.items.select(Ast::Spread).size

      error! :destructuring_multiple_spreads do
        block "An array destructuring can only contain one spread notation " \
              "because otherwise I don't know how to distribute the " \
              "leftover items."

        block do
          text "This array destructuring contains"
          bold spreads.to_s
          text "spread notations:"
        end

        snippet node
      end if spreads > 1

      node.items.each_with_index do |item, index|
        case item
        when Ast::Spread
          if index == (node.items.size - 1)
            cache[item] = condition
            case variable = item.variable
            when Ast::Variable
              variables << {variable.value, condition, item}
            end
          else
            error! :destructuring_multiple_spreads do
              block "The spread notation can only appear as the last item " \
                    "in a destructuring."

              snippet node
            end
          end
        else
          destructure(item, condition.parameters[0], variables)
        end
      end

      variables
    end

    def destructure(
      node : Ast::RecordDestructuring,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope,
    )
      case condition
      when Record
        cache[node] = condition

        node.fields.each do |field|
          error! :destructuring_record_field_missing do
            snippet "A required key is not present on this record:", condition
            snippet "The key is here:", field.key.not_nil!
          end unless type = condition.fields[field.key.try(&.value)]?

          destructure(field.value, type, variables)
        end

        variables
      else
        error! :destructuring_non_record do
          block "You are trying to match record patterns against non record" \
                "in a destructuring."

          snippet node
        end
      end
    end

    def destructure(
      node : Ast::TupleDestructuring,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope,
    )
      destructuring_type_mismatch(
        expected: Type.new("Tuple"),
        got: condition,
        node: node,
      ) unless condition.name == "Tuple"

      error! :destructuring_tuple_mismatch do
        block do
          text "This destructuring of a tuple does not match the given " \
               "tuple. I was expecting a tuple with"
          bold node.items.size.to_s
          text "items."
        end

        snippet "Instead it is this:", condition
        snippet "The destructuring in question is here:", node
      end if node.items.size > condition.parameters.size

      node.items.each_with_index do |item, index|
        destructure(item, condition.parameters[index], variables)
      end

      variables
    end

    def destructure(
      node : Ast::TypeDestructuring,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope,
    )
      track_references(node)

      cache[node] = condition
      case condition
      when Tags
        if tag = condition.options.find(&.name.==(node.variant.value))
          node.items.each_with_index do |param, index|
            error! :destructuring_no_parameter do
              block do
                text "You are trying to destructure the"
                bold (index + 1).to_s
                text "parameter from the tag:"
                bold tag.name
              end

              block do
                text "The tag only has"
                bold tag.parameters.size.to_s
                text "parameters."
              end

              snippet "You are trying to destructure it here:", param
              snippet "The type of the tag is:", tag
            end unless field = tag.parameters[index]?

            destructure(param, field, variables)
          end

          return variables
        end
      end || begin
        name =
          if node.name && node.variant
            node.name.try(&.value)
          else
            condition.name
          end

        type_definition =
          ast.type_definitions.find(&.name.value.==(name))

        variant =
          if type_definition
            case fields = type_definition.fields
            when Array(Ast::TypeVariant)
              fields.find(&.value.value.==(node.variant.value))
            end
          end

        if type_definition && variant
          lookups[node] = {variant, type_definition}

          type = resolve(type_definition)

          unified =
            Comparer.compare(type, condition)

          destructuring_type_mismatch(
            expected: condition,
            node: node,
            got: type,
          ) unless unified

          node.items.each_with_index do |param, index|
            case param
            when Ast::Variable
              error! :destructuring_no_parameter do
                block do
                  text "You are trying to destructure the"
                  bold (index + 1).to_s
                  text "parameter from the type variant:"
                  bold variant.value.value
                end

                block do
                  text "The variant only has"
                  bold variant.parameters.size.to_s
                  text "parameters."
                end

                snippet "You are trying to destructure it here:", param
                snippet "The option is defined here:", variant
              end unless field = variant.parameters[index]?

              case field
              when Ast::TypeDefinitionField
                type =
                  resolve(field.type)

                destructure(param, type, variables)
              else
                variant_type =
                  resolve(variant.parameters[index]).not_nil!

                mapping = {} of String => Checkable

                type_definition.parameters.each_with_index do |param2, index2|
                  mapping[param2.value] = condition.parameters[index2]
                end

                resolved_type =
                  Comparer.fill(variant_type, mapping).not_nil!

                destructure(param, resolved_type, variables)
              end
            else
              sub_type =
                case item = variant.parameters[index]
                when Ast::Type
                  resolve(item)
                when Ast::TypeVariable
                  unified.parameters[type_definition.parameters.index! { |variable| variable.value == item.value }]
                when Ast::TypeDefinitionField
                  resolve(item.type)
                else
                  VOID # Can't happen
                end

              destructure(param, sub_type, variables)
            end
          end

          return variables
        elsif node.items.empty? &&
              (entity_name = node.name.try(&.value)) &&
              (parent = scope.resolve(entity_name, node).try(&.node)) &&
              (entity = scope.resolve(node.variant.value, parent).try(&.node))
          check!(parent)
          lookups[node] = {entity, parent}
          return destructure(entity, condition, variables)
        elsif type_definition
          error! :destructuring_type_variant_missing do
            block do
              text "I could not find the variant"
              bold %("#{node.variant.value}")
              text "of type"
              bold %("#{type_definition.name.value}")
              text "for a destructuring:"
            end

            snippet node
            snippet "The type is defined here:", type_definition
          end
        end
      end

      error! :destructuring_type_missing do
        snippet "I could not find the type for a destructuring with the name:", name.to_s
        snippet "The destructuring in question is here:", node
      end
    end
  end
end
