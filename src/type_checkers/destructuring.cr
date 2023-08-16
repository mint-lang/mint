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
      error :destructuring_type_mismatch do
        block "A value does not match its supposed type."

        snippet "I was expecting:", expected
        snippet "Instead it is:", got

        snippet node
      end
    end

    def destructure(
      node : Nil,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope
    )
      variables
    end

    def destructure(
      node : Ast::Node,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope
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
      variables : Array(VariableScope) = [] of VariableScope
    )
      variables.tap(&.push({node.value, condition, node}))
    end

    def destructure(
      node : Ast::ArrayDestructuring,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope
    )
      destructuring_type_mismatch(
        expected: ARRAY,
        got: condition,
        node: node,
      ) unless Comparer.compare(ARRAY, condition)

      spreads =
        node.items.select(Ast::Spread).size

      error :destructuring_multiple_spreads do
        block do
          text "This array destructuring contains"
          code spreads.to_s
          text "spread notations."
        end

        block "An array destructuring can only contain one spread notation."

        snippet node
      end if spreads > 1

      node.items.each do |item|
        case item
        when Ast::Spread
          variables << {item.variable.value, condition, item}
        else
          destructure(item, condition.parameters[0], variables)
        end
      end

      variables
    end

    def destructure(
      node : Ast::TupleDestructuring,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope
    )
      destructuring_type_mismatch(
        expected: Type.new("Tuple"),
        got: condition,
        node: node,
      ) unless condition.name == "Tuple"

      error :destructuring_tuple_mismatch do
        block "This destructuring of a tuple does not match the given tuple."
        block do
          text "I was expecting a tuple with"
          bold node.parameters.size.to_s
          text "parameters."
        end

        snippet "Instead it is this:", condition

        snippet node
      end if node.parameters.size > condition.parameters.size

      node.parameters.each_with_index do |item, index|
        destructure(item, condition.parameters[index], variables)
      end

      variables
    end

    def destructure(
      node : Ast::EnumDestructuring,
      condition : Checkable,
      variables : Array(VariableScope) = [] of VariableScope
    )
      parent =
        ast.enums.find(&.name.value.==(node.name.try &.value))

      error :destructuring_enum_missing do
        block do
          text "I could not find the enum for a destructuring:"
          bold node.name.try(&.value).to_s
        end

        snippet node
      end unless parent

      option =
        parent.options.find(&.value.value.==(node.option.value))

      error :destructuring_enum_option_missing do
        block do
          text "I could not find the option"
          bold node.option.value
          text "of enum"
          bold parent.name.value
          text "for a destructuring."
        end

        snippet "You tried to reference it here:", node
        snippet "The enum is defined here:", parent
      end unless option

      lookups[node] = option

      type = resolve(parent)

      unified =
        Comparer.compare(type, condition)

      destructuring_type_mismatch(
        expected: condition,
        node: node,
        got: type,
      ) unless unified

      case option_param = option.parameters.first?
      when Ast::EnumRecordDefinition
        node.parameters.each_with_index do |param, index|
          record =
            resolve(option_param).as(Record)

          case param
          when Ast::Variable
            found = option_param.fields.find do |field|
              case param
              when Ast::Variable
                param.value == field.key.value
              end
            end

            error :destructuring_record_field_missing do
              block do
                text "I could not find the field"
                bold param.value
                text "of the"
                bold record.name
                text "for a destructuring."
              end

              snippet "You tried to reference it here:", param
            end unless found

            destructure(param, record.fields[param.value], variables)
          else
            name =
              option_param.fields[index].key.value

            destructure(param, record.fields[name], variables)
          end
        end
      else
        node.parameters.each_with_index do |param, index|
          case param
          when Ast::Variable
            error :destructuring_no_parameter do
              block do
                text "You are trying to destructure the"
                bold index.to_s
                text "parameter from the enum option:"
                bold option.value.value
              end

              block do
                text "The option only has"
                bold option.parameters.size.to_s
                text "parameters."
              end

              snippet "You are trying to destructure it here:", param
              snippet "The option is defined here:", option
            end unless option.parameters[index]?

            option_type =
              resolve(option.parameters[index]).not_nil!

            mapping = {} of String => Checkable

            parent.parameters.each_with_index do |param2, index2|
              mapping[param2.value] = condition.parameters[index2]
            end

            resolved_type =
              Comparer.fill(option_type, mapping).not_nil!

            destructure(param, resolved_type, variables)
          else
            sub_type =
              case item = option.parameters[index]
              when Ast::Type
                resolve(item)
              when Ast::TypeVariable
                unified.parameters[parent.parameters.index! { |enum_item| enum_item.value == item.value }]
              else
                VOID # Can't happen
              end

            destructure(param, sub_type, variables)
          end
        end
      end

      variables
    end
  end
end
