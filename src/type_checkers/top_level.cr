module Mint
  class TypeChecker
    def self.check(node : Ast) : Artifacts
      new(node).check
    end

    def check(node : Ast) : Checkable
      node
        .components
        .find(&.name.==("Main"))
        .try { |component| resolve component }

      # resolve node.providers
      # resolve node.components
      # resolve node.modules
      # resolve node.stores
      resolve node.routes
      # resolve node.suites
      resolve node.enums

      NEVER
    end
  end
end
