module Mint
  class TypeChecker
    def check(node : Ast::ConstantVariable) : Checkable
      item = lookup_with_level(node)

      raise VariableMissing, {
        "name" => node.name,
        "node" => node,
      } unless item

      variables[node] = item

      resolve item[0]
    end
  end
end
