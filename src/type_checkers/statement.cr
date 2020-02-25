module Mint
  class TypeChecker
    def check(node : Ast::Statement) : Checkable
      node.variables.each { |variable| check_variable variable }

      types[node] = resolve node.expression
    end
  end
end
