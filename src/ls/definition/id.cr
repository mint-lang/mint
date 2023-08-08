module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::Id, workspace : Workspace, stack : Array(Ast::Node))
        found =
          workspace.ast.type_definitions.find(&.name.value.==(node.value)) ||
            workspace.ast.stores.find(&.name.value.==(node.value)) ||
            find_component(workspace, node.value)

        if found.nil? && (next_node = stack[1])
          return definition(next_node, workspace, stack)
        end

        return if Core.ast.nodes.includes?(found)

        case found
        when Ast::Store, Ast::Component, Ast::TypeDefinition
          location_link node, found.name, found
        end
      end
    end
  end
end
