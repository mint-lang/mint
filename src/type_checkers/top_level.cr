module Mint
  class TypeChecker
    def self.check(node : Ast) : Artifacts
      new(node).check
    end

    def check(node : Ast) : Checkable
      resolve node.providers
      resolve node.components
      resolve node.modules
      resolve node.stores
      resolve node.routes
      resolve node.suites
      resolve node.enums

      NEVER
    end
  end
end
