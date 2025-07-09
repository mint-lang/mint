module Mint
  class TypeChecker
    def self.check(node : Ast, entities : Array(String) = [] of String) : Artifacts
      new(node).check(entities)
    end

    def check(node : Ast, entities : Array(String) = [] of String) : Checkable
      node
        .type_definitions
        .find(&.name.value.==("Maybe"))
        .try { |item| resolve item }

      node
        .type_definitions
        .find(&.name.value.==("Result"))
        .try { |item| resolve item }

      if entities.empty?
        # Resolve the Main component
        ast.main.try { |component| resolve component }

        resolve node.routes
        resolve node.suites
      else
        entities.each do |qualified|
          if item = scope.resolve_qualified(qualified)
            exported.add(item)
            resolve item
            item.parent.try do |parent|
              references.link(item, parent)
              check!(parent)
            end
          end
        end
      end

      resolve node.components.select(&.global?)

      # We are turning off checking here which means that what we check after
      # this will not be compiled.
      self.checking = false

      if check_everything?
        check_all node.components
        check_all node.unified_modules

        resolve node.providers
        resolve node.stores
        resolve node.type_definitions
      end

      VOID
    end
  end
end
