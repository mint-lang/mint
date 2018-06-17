module Mint
  class TypeChecker
    def check(node : Ast::StringLiteral) : Checkable
      STRING
    end
  end
end
