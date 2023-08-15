module Mint
  class TypeChecker
    def check(node : Ast::Connect) : Checkable
      store = ast.stores.find(&.name.value.==(node.store.value))

      error :connect_not_found_store do
        block do
          text "I was looking for the store"
          bold node.store.value
          text "but could not find it."
        end

        snippet node
      end unless store

      resolve store

      node.keys.each do |key|
        key_value = key.variable.value

        found =
          store.functions.find(&.name.value.==(key_value)) ||
            store.states.find(&.name.value.==(key_value)) ||
            store.gets.find(&.name.value.==(key_value)) ||
            store.constants.find(&.name.value.==(key_value))

        error :connect_not_found_member do
          block do
            text "The"
            bold key_value
            text "function, property or computed property does not exists for the store:"
            bold node.store.value
          end

          snippet node
        end unless found

        cache[key] = resolve found
        lookups[key] = found
      end

      VOID
    end
  end
end
