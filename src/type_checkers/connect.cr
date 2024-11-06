module Mint
  class TypeChecker
    def check(node : Ast::Connect) : Checkable
      store =
        ast.stores.find(&.name.value.==(node.store.value))

      error! :connect_not_found_store do
        block do
          text "I was looking for the store"
          bold node.store.value
          text "but could not find it."
        end

        snippet node.store
      end unless store

      resolve store

      node.keys.each do |key|
        error! :connect_not_found_member do
          block do
            text "The entity"
            bold %("#{key.name.value}")
            text "does not exist in the connected store."
          end

          snippet "The connect in question is here:", node
        end unless found = scope.resolve(key.name.value, store).try(&.node)

        cache[key] =
          resolve found

        lookups[key] =
          {found, store}
      end

      VOID
    end
  end
end
