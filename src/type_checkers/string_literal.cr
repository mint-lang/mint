module Mint
  class TypeChecker
    def check(node : Ast::StringLiteral) : Type
      STRING
    end
  end
end
