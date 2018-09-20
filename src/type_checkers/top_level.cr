module Mint
  class TypeChecker
    def self.check(node : Ast) : Artifacts
      new(node).check
    end

    def check(node : Ast) : Checkable
      # Resolve the Main component
      node
        .components
        .find(&.name.==("Main"))
        .try { |component| resolve component }

      # Resolve routes
      resolve node.routes

      # TODO: Don't egarerly resolve enums when it's figured out how to access
      # them in JS properly
      resolve node.enums

      # We are turning off checking here which means that what we check after
      # this will not be compiled.
      self.checking = false

      resolve node.providers
      resolve node.components
      resolve node.modules
      resolve node.stores
      resolve node.suites

      NEVER
    end
  end
end
