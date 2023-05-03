module Mint
  class TypeChecker
    type_error CaseBranchNotMatchCondition
    type_error CaseBranchTupleMismatch
    type_error CaseBranchNotTuple
    type_error CaseBranchMultipleSpreads
    type_error CaseBranchNotArray

    type_error EnumDestructuringNoParameter
    type_error EnumDestructuringTypeMissing
    type_error EnumDestructuringEnumMissing

    def destructure(
      node : Nil,
      condition : Checkable,
      variables : Array(Tuple(String, Checkable, Ast::Node)) = [] of Tuple(String, Checkable, Ast::Node)
    )
      variables
    end

    def destructure(
      node : Ast::Node,
      condition : Checkable,
      variables : Array(Tuple(String, Checkable, Ast::Node)) = [] of Tuple(String, Checkable, Ast::Node)
    )
      type =
        resolve(node)

      raise CaseBranchNotMatchCondition, {
        "expected" => condition,
        "got"      => type,
        "node"     => node,
      } unless Comparer.compare(type, condition)

      variables
    end

    def destructure(
      node : Ast::ArrayDestructuring,
      condition : Checkable,
      variables : Array(Tuple(String, Checkable, Ast::Node)) = [] of Tuple(String, Checkable, Ast::Node)
    )
      raise CaseBranchNotArray, {
        "got"  => condition,
        "node" => node,
      } unless condition.name == "Array"

      spreads =
        node.items.select(Ast::Spread).size

      raise CaseBranchMultipleSpreads, {
        "count" => spreads.to_s,
        "node"  => node,
      } if spreads > 1

      node.items.each do |item|
        case item
        when Ast::Variable
          variables << {item.value, condition.parameters[0], item}
        when Ast::Spread
          variables << {item.variable.value, condition, item}
        else
          # TODO: Do other destructurings
        end
      end

      variables
    end

    def destructure(
      node : Ast::TupleDestructuring,
      condition : Checkable,
      variables : Array(Tuple(String, Checkable, Ast::Node)) = [] of Tuple(String, Checkable, Ast::Node)
    )
      raise CaseBranchNotTuple, {
        "got"  => condition,
        "node" => node,
      } unless condition.name == "Tuple"

      raise CaseBranchTupleMismatch, {
        "size" => node.parameters.size.to_s,
        "got"  => condition,
        "node" => node,
      } if node.parameters.size > condition.parameters.size

      node.parameters.each_with_index do |variable, index|
        case variable
        when Ast::Variable
          variables << {variable.value, condition.parameters[index], variable}
        when Ast::TupleDestructuring
          destructure(variable, condition.parameters[index], variables)
        else
          # TODO: Do other destructurings
        end
      end

      variables
    end

    def destructure(
      node : Ast::EnumDestructuring,
      condition : Checkable,
      variables : Array(Tuple(String, Checkable, Ast::Node)) = [] of Tuple(String, Checkable, Ast::Node)
    )
      parent =
        ast.enums.find(&.name.value.==(node.name.try &.value))

      raise EnumDestructuringTypeMissing, {
        "name" => node.name,
        "node" => node,
      } unless parent

      option =
        parent.options.find(&.value.value.==(node.option.value))

      raise EnumDestructuringEnumMissing, {
        "parent_name" => parent.name,
        "name"        => node.option,
        "parent"      => parent,
        "node"        => node,
      } unless option

      lookups[node] = option

      type = resolve(parent)

      raise CaseBranchNotMatchCondition, {
        "expected" => condition,
        "got"      => type,
        "node"     => node,
      } unless Comparer.compare(type, condition)

      case option_param = option.parameters[0]?
      when Ast::EnumRecordDefinition
        node.parameters.each do |param|
          found = option_param.fields.find do |field|
            case param
            when Ast::TypeVariable
              param.value == field.key.value
            end
          end

          raise TypeError.new unless found

          case param
          when Ast::TypeVariable
            record =
              resolve(option_param).as(Record)

            variables << {param.value, record.fields[param.value], param}
          end
        end
      else
        node.parameters.each_with_index do |param, index|
          case param
          when Ast::TypeVariable
            raise EnumDestructuringNoParameter, {
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

            variables << {param.value, resolved_type, param}
          end
        end
      end

      variables
    end
  end
end
