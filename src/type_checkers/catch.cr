module Mint
  class TypeChecker
    def check(node : Ast::Catch) : Type
      check node.expression
    end
  end
end
