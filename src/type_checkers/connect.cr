module Mint
  class TypeChecker
    type_error ConnectNotFoundMember
    type_error ConnectNotFoundStore

    def check(node : Ast::Connect) : Checkable
      store = ast.stores.find(&.name.==(node.store))

      raise ConnectNotFoundStore, {
        "store" => node.store,
        "node"  => node,
      } unless store

      resolve store

      node.keys.each do |key|
        found =
          store.functions.find(&.name.value.==(key.value)) ||
            store.states.find(&.name.value.==(key.value)) ||
            store.gets.find(&.name.value.==(key.value))

        raise ConnectNotFoundMember, {
          "store" => node.store,
          "key"   => key.value,
          "node"  => node,
        } unless found
      end

      NEVER
    end
  end
end
