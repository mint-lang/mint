module Mint
  class TypeChecker
    type_error CaseBranchNotMatchCondition
    type_error CaseBranchTupleMismatch
    type_error CaseBranchNotTuple
    type_error CaseBranchMultipleSpreads
    type_error CaseBranchNotArray

    def check(node : Ast::CaseBranch, condition : Checkable) : Checkable
      resolve_expression = ->{
        case expression = node.expression
        when Array(Ast::CssDefinition)
          resolve expression
          NEVER
        when Ast::Node
          resolve expression
        else
          NEVER
        end
      }

      check_match = ->(item : Ast::Node) {
        match = resolve item

        raise CaseBranchNotMatchCondition, {
          "expected" => condition,
          "got"      => match,
          "node"     => item,
        } unless Comparer.compare(match, condition)
      }

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

          variables =
            item.items.compact_map do |variable|
              case variable
              when Ast::Variable
                {variable.value, condition.parameters[0], variable}
              when Ast::Spread
                {variable.variable.value, condition, variable.variable}
              else
                # ignore
              end
            end

          scope(variables) do
            resolve_expression.call
          end
        when Ast::TupleDestructuring
          raise CaseBranchNotTuple, {
            "got"  => condition,
            "node" => item,
          } unless condition.name == "Tuple"

          raise CaseBranchTupleMismatch, {
            "size" => item.parameters.size.to_s,
            "got"  => condition,
            "node" => item,
          } if item.parameters.size > condition.parameters.size

          variables =
            item.parameters.map_with_index do |variable, index|
              {variable.value, condition.parameters[index], variable}
            end

          scope(variables) do
            resolve_expression.call
          end
        when Ast::EnumDestructuring
          check_match.call(item)

          entity =
            ast.enums.find(&.name.==(item.name)).not_nil!

          option =
            entity.options.find(&.value.==(item.option)).not_nil!

          variables =
            case option_param = option.parameters[0]?
            when Ast::EnumRecordDefinition
              item.parameters.map do |param|
                record =
                  resolve(option_param).as(Record)

                {param.value, record.fields[param.value], param}
              end
            else
              item.parameters.map_with_index do |param, index|
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
            end

          scope(variables) do
            resolve_expression.call
          end
        else
          check_match.call(item)
        end
      end || resolve_expression.call
    end
  end
end
