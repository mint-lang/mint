module Mint
  class TypeChecker
    type_error CaseBranchNotMatchCondition

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

      node.match.try do |item|
        match = resolve item

        raise CaseBranchNotMatchCondition, {
          "expected" => condition,
          "got"      => match,
          "node"     => item,
        } unless Comparer.compare(match, condition)

        case item
        when Ast::EnumDestructuring
          variables =
            item.parameters.map_with_index do |param, index|
              entity =
                ast.enums.find(&.name.==(item.name)).not_nil!

              option =
                entity.options.find(&.value.==(item.option)).not_nil!

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

          scope(variables) do
            resolve_expression.call
          end
        end
      end || resolve_expression.call
    end
  end
end
