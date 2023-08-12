module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::Connect, workspace : Workspace, stack : Array(Ast::Node))
        return unless cursor_intersects?(node.store)

        return unless store =
                        workspace.ast.stores.find(&.name.value.==(node.store.value))

        location_link node.store, store.name, store
      end
    end
  end
end
