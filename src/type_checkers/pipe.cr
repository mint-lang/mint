module Mint
  class TypeChecker
    def check(node : Ast::Pipe) : Checkable
      resolve node.call
    end
  end
end
