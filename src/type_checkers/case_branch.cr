module Mint
  class TypeChecker
    type_error CaseBranchNotMatchCondition

    def check(node : Ast::CaseBranch, condition : Checkable) : Checkable
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
                ast.enums.find(&.name.==(item.name))

              option =
                entity.not_nil!.options.find(&.value.==(item.option))

              option_type =
                resolve option.not_nil!.parameters[index]

              condition_type =
                condition.parameters[index]

              resolved_type =
                Comparer.compare(option_type, condition_type)

              {param.value, resolved_type.not_nil!}
            end

          scope(variables) do
            resolve node.expression
          end
        end
      end || resolve node.expression
    end
  end
end
