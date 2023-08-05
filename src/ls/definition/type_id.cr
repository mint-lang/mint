module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::TypeId, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        case stack[1]?
        when Ast::ModuleAccess
          links = workspace.ast.modules.select(&.name.value.==(node.value))
            .reject(&.in?(Core.ast.nodes))
            .map do |mod|
              location_link server, node, mod.name, mod
            end

          return links.first if links.size == 1
          return links unless links.empty?
        end

        found =
          workspace.ast.enums.find(&.name.value.==(node.value)) ||
            workspace.ast.records.find(&.name.value.==(node.value)) ||
            workspace.ast.stores.find(&.name.value.==(node.value)) ||
            find_component(workspace, node.value)

        if found.nil? && (next_node = stack[1])
          return definition(next_node, server, workspace, stack)
        end

        return if Core.ast.nodes.includes?(found)

        case found
        when Ast::Store, Ast::Enum, Ast::Component, Ast::RecordDefinition
          location_link server, node, found.name, found
        end
      end
    end
  end
end
