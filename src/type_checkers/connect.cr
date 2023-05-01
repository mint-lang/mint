module Mint
  class TypeChecker
    type_error ConnectNotFoundMember
    type_error ConnectNotFoundStore

    def check(node : Ast::Connect) : Checkable
      store = ast.stores.find(&.name.value.==(node.store.value))

      raise ConnectNotFoundStore, {
        "store" => node.store.value,
        "node"  => node,
      } unless store

      resolve store

      node.keys.each do |key|
        key_value = key.variable.value

        found =
          store.functions.find(&.name.value.==(key_value)) ||
            store.states.find(&.name.value.==(key_value)) ||
            store.gets.find(&.name.value.==(key_value)) ||
            store.constants.find(&.name.==(key_value))

        raise ConnectNotFoundMember, {
          "key"   => key_value,
          "store" => node.store.value,
          "node"  => node,
        } unless found

        cache[key] = resolve found
        lookups[key] = found
      end

      NEVER
    end
  end
end
