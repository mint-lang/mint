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

              {param.value, resolve option.not_nil!.parameters[index]}
            end

          scope(variables) do
            resolve node.expression
          end
        end
      end || resolve node.expression
    end
  end
end
