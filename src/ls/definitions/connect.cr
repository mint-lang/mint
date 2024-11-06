module Mint
  module LS
    class Definitions
      def definition(node : Ast::Connect)
        return unless cursor_intersects?(node.store)

        return unless store =
                        @type_checker.artifacts.ast.stores
                          .find(&.name.value.==(node.store.value))

        location_link node.store, store.name, store
      end
    end
  end
end
