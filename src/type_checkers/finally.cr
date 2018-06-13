module Mint
  class TypeChecker
    def check(node : Ast::Finally) : Type
      resolve node.expression
    end
  end
end
