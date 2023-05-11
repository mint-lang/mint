module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::Type, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        return unless cursor_intersects?(node.name)

        enum_node =
          workspace.ast.enums.find(&.name.value.==(node.name.value))

        if enum_node
          return if Core.ast.enums.includes?(enum_node)

          location_link server, node.name, enum_node.name, enum_node
        else
          return unless record =
                          workspace.ast.records.find(&.name.value.==(node.name.value))

          return if Core.ast.records.includes?(record)

          location_link server, node.name, record.name, record
        end
      end
    end
  end
end
