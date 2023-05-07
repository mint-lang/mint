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

    type_error DestructuringMultipleSpreads
    type_error DestructuringTupleMismatch
    type_error DestructuringTypeMismatch
    type_error DestructuringNoParameter

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

      raise DestructuringTypeMismatch, {
        "expected" => condition,
        "got"      => type,
        "node"     => node,
      } unless Comparer.compare(type, condition)

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
      raise DestructuringTypeMismatch, {
        "expected" => ARRAY,
        "got"      => condition,
        "node"     => node,
      } unless Comparer.compare(ARRAY, condition)

      spreads =
        node.items.select(Ast::Spread).size

      raise DestructuringMultipleSpreads, {
        "count" => spreads.to_s,
        "node"  => node,
      } if spreads > 1

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
      raise DestructuringTypeMismatch, {
        "expected" => Type.new("Tuple"),
        "got"      => condition,
        "node"     => node,
      } unless condition.name == "Tuple"

      raise DestructuringTupleMismatch, {
        "size" => node.parameters.size.to_s,
        "got"  => condition,
        "node" => node,
      } if node.parameters.size > condition.parameters.size

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

      raise EnumIdTypeMissing, {
        "name" => node.name,
        "node" => node,
      } unless parent

      option =
        parent.options.find(&.value.value.==(node.option.value))

      raise EnumIdEnumMissing, {
        "parent_name" => parent.name.value,
        "name"        => node.option.value,
        "parent"      => parent,
        "node"        => node,
      } unless option

      lookups[node] = option

      type = resolve(parent)

      unified =
        Comparer.compare(type, condition)

      raise DestructuringTypeMismatch, {
        "expected" => condition,
        "got"      => type,
        "node"     => node,
      } unless unified

      case option_param = option.parameters[0]?
      when Ast::EnumRecordDefinition
        node.parameters.each do |param|
          found = option_param.fields.find do |field|
            case param
            when Ast::Variable
              param.value == field.key.value
            end
          end

          raise TypeError.new unless found

          case param
          when Ast::Variable
            record =
              resolve(option_param).as(Record)

            destructure(param, record.fields[param.value], variables)
          end
        end
      else
        node.parameters.each_with_index do |param, index|
          case param
          when Ast::Variable
            raise DestructuringNoParameter, {
              "size"   => option.parameters.size.to_s,
              "index"  => index.to_s,
              "name"   => option.value,
              "option" => option,
              "node"   => param,
            } unless option.parameters[index]?

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
                NEVER # Can't happen
              end

            destructure(param, sub_type, variables)
          end
        end
      end

      variables
    end
  end
end
