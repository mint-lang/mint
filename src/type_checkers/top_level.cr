module Mint
  class TypeChecker
    def self.check(node : Ast) : Artifacts
      new(node).check
    end

    def check(node : Ast) : Type
      resolve node.providers
      resolve node.components
      resolve node.modules
      resolve node.stores
      resolve node.routes
      resolve node.suites

      NEVER
    end
  end
end
