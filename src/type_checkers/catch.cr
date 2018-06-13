module Mint
  class TypeChecker
    def check(node : Ast::Catch) : Type
      resolve node.expression
    end
  end
end
