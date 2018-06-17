module Mint
  class TypeChecker
    def check(node : Ast::Finally) : Checkable
      resolve node.expression
    end
  end
end
