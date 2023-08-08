module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::Type, workspace : Workspace, stack : Array(Ast::Node))
        return unless cursor_intersects?(node.name)

        return unless record =
                        workspace.ast.type_definitions.find(&.name.value.==(node.name.value))

        return if Core.ast.type_definitions.includes?(record)

        location_link node.name, record.name, record
      end
    end
  end
end
