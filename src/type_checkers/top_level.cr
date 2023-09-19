module Mint
  class TypeChecker
    def self.check(node : Ast) : Artifacts
      new(node).check
    end

    def check(node : Ast) : Checkable
      # Resolve the Main component
      node
        .components
        .find(&.name.value.==("Main"))
        .try { |component| resolve component }

      node
        .type_definitions
        .find(&.name.value.==("Maybe"))
        .try { |item| resolve item }

      node
        .type_definitions
        .find(&.name.value.==("Result"))
        .try { |item| resolve item }

      node
        .unified_modules
        .find(&.name.value.==("Html.Event"))
        .try do |item|
          resolve item

          item
            .functions
            .find(&.name.value.==("fromEvent"))
            .try do |function|
              resolve function
            end
        end

      web_components.each do |component|
        node.components.find(&.name.value.==(component)).try do |item|
          resolve item
        end
      end

      # Resolve routes
      resolve node.routes
      resolve node.suites
      resolve node.components.select(&.global?)

      # We are turning off checking here which means that what we check after
      # this will not be compiled.
      self.checking = false

      check_all node.components
      check_all node.unified_modules

      resolve node.providers
      resolve node.stores
      resolve node.type_definitions

      VOID
    end
  end
end
