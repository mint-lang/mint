module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::EnumDestructuring, workspace : Workspace, stack : Array(Ast::Node))
        return unless name = node.name
        return unless enum_node =
                        workspace.ast.enums.find(&.name.value.==(name.value))

        return if Core.ast.enums.includes?(enum_node)

        case
        when cursor_intersects?(name)
          location_link name, enum_node.name, enum_node
        when cursor_intersects?(node.option)
          return unless option =
                          enum_node.try &.options.find(&.value.value.==(node.option.value))

          location_link node.option, option.value, option
        end
      end
    end
  end
end
