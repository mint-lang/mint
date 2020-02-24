module Mint
  class TypeChecker
    def check(node : Ast::Statement) : Checkable
      node.variables.try(&.each do |variable|
        check_variable variable
      end)

      types[node] = resolve node.expression
    end
  end
end
