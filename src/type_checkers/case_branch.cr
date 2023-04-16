module Mint
  class TypeChecker
    type_error CaseBranchNotMatchCondition
    type_error CaseBranchTupleMismatch
    type_error CaseBranchNotTuple
    type_error CaseBranchMultipleSpreads
    type_error CaseBranchNotArray

    protected def resolve_expression(node : Ast::CaseBranch)
      case expression = node.expression
      when Array(Ast::CssDefinition)
        resolve expression
        NEVER
      when Ast::Node
        resolve expression
      else
        NEVER
      end
    end

    protected def check_match(node : Ast::Node, condition : Checkable)
      match = resolve node

      raise CaseBranchNotMatchCondition, {
        "expected" => condition,
        "got"      => match,
        "node"     => node,
      } unless Comparer.compare(match, condition)
    end

    def check(node : Ast::CaseBranch, condition : Checkable) : Checkable
      node.match.try do |item|
        case item
        when Ast::ArrayDestructuring
          raise CaseBranchNotArray, {
            "got"  => condition,
            "node" => node,
          } unless condition.name == "Array"

          spreads =
            item.items.select(Ast::Spread).size

          raise CaseBranchMultipleSpreads, {
            "count" => spreads.to_s,
            "node"  => node,
          } if spreads > 1

          scope(destructuring_variables(item, condition)) do
            resolve_expression(node)
          end
        when Ast::TupleDestructuring
          _check(item, condition)

          scope(destructuring_variables(item, condition)) do
            resolve_expression(node)
          end
        when Ast::EnumDestructuring
          check_match(item, condition)

          scope(destructuring_variables(item, condition)) do
            resolve_expression(node)
          end
        else
          check_match(item, condition)
        end
      end || resolve_expression(node)
    end

    private def _check(node : Ast::TupleDestructuring, condition : Checkable)
      raise CaseBranchNotTuple, {
        "got"  => condition,
        "node" => node,
      } unless condition.name == "Tuple"

      raise CaseBranchTupleMismatch, {
        "size" => node.parameters.size.to_s,
        "got"  => condition,
        "node" => node,
      } if node.parameters.size > condition.parameters.size
    end

    private def destructuring_variables(item : Ast::EnumDestructuring, condition)
      entity =
        ast.enums.find!(&.name.==(item.name))

      option =
        entity.options.find!(&.value.==(item.option))

      case option_param = option.parameters[0]?
      when Ast::EnumRecordDefinition
        item.parameters.compact_map do |param|
          case param
          when Ast::TypeVariable
            record =
              resolve(option_param).as(Record)

            {param.value, record.fields[param.value], param}
          end
        end
      else
        item.parameters.map_with_index do |param, index|
          case param
          when Ast::TypeVariable
            option_type =
              resolve(option.parameters[index]).not_nil!

            mapping = {} of String => Checkable

            entity.parameters.each_with_index do |param2, index2|
              mapping[param2.value] = condition.parameters[index2]
            end

            resolved_type =
              Comparer.fill(option_type, mapping)

            {param.value, resolved_type.not_nil!, param}
          end
        end.compact
      end
    end

    private def destructuring_variables(item : Ast::TupleDestructuring, condition)
      item.parameters.map_with_index do |variable, index|
        case variable
        when Ast::Variable
          [{variable.value, condition.parameters[index], variable}]
        when Ast::TupleDestructuring
          subcondition = condition.parameters[index]
          _check(variable, subcondition)
          destructuring_variables(variable, subcondition)
        end
      end.compact.flatten
    end

    private def destructuring_variables(item : Ast::ArrayDestructuring, condition)
      item.items.compact_map do |variable|
        case variable
        when Ast::Variable
          {variable.value, condition.parameters[0], variable}
        when Ast::Spread
          {variable.variable.value, condition, variable.variable}
        end
      end
    end
  end
end
