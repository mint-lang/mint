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

      node
        .enums
        .find(&.name.==("Maybe"))
        .try do |item|
          resolve item
        end

      node
        .enums
        .find(&.name.==("Result"))
        .try do |item|
          resolve item
        end

      node
        .modules
        .find(&.name.==("Html.Event"))
        .try do |item|
          resolve item

          item
            .functions
            .find(&.name.value.==("fromEvent"))
            .try do |function|
              scope item do
                resolve function
              end
            end
        end

      # Resolve routes
      resolve node.routes
      resolve node.suites
      resolve node.components.select(&.global)

      # We are turning off checking here which means that what we check after
      # this will not be compiled.
      self.checking = false

      check_all node.components
      check_all node.modules

      resolve node.providers
      resolve node.stores
      resolve node.enums

      NEVER
    end
  end
end
