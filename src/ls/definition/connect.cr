module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::Connect, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        return unless cursor_intersects?(node.store)

        return unless store =
                        workspace.ast.stores.find(&.name.value.==(node.store.value))

        location_link server, node.store, store.name, store
      end
    end
  end
end
