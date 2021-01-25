module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::Get, workspace) : Array(String?)
        entity =
          workspace.ast.components.find(&.gets.includes?(node)) ||
            workspace.ast.stores.find(&.gets.includes?(node))

        name =
          case entity
          when Ast::Component
            entity.name
          when Ast::Store
            entity.name
          else
            ""
          end

        type =
          node.type.try do |item|
            ": #{workspace.formatter.format(item)}"
          end

        [
          "**#{name}.#{node.name.value}#{type}**\n",
          node.comment.try(&.value.strip),
        ]
      end
    end
  end
end
