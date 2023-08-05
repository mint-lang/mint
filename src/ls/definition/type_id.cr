module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::TypeId, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        found =
          workspace.ast.enums.select(&.name.value.==(node.value)) +
            workspace.ast.records.select(&.name.value.==(node.value)) +
            workspace.ast.stores.select(&.name.value.==(node.value)) +
            workspace.ast.components.select(&.name.value.==(node.value)) +
            workspace.ast.modules.select(&.name.value.==(node.value))

        if found.empty? && (next_node = stack[1]?)
          return definition(next_node, server, workspace, stack)
        end

        links = found
          .reject(&.in?(Core.ast.nodes))
          .map do |mod|
            case mod
            when Ast::Store, Ast::Enum, Ast::Component, Ast::RecordDefinition, Ast::Module
              location_link server, node, mod.name, mod
            end
          end
          .compact

        return links if links.size > 1

        links.first?
      end
    end
  end
end
