module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::Function, workspace) : Array(String)
        entity =
          workspace.ast.unified_modules.find(&.functions.includes?(node)) ||
            workspace.ast.components.find(&.functions.includes?(node)) ||
            workspace.ast.providers.find(&.functions.includes?(node)) ||
            workspace.ast.stores.find(&.functions.includes?(node))

        name =
          case entity
          when Ast::Component
            entity.name
          when Ast::Provider
            entity.name
          when Ast::Store
            entity.name
          when Ast::Module
            entity.name
          end

        arguments =
          workspace.formatter.format_arguments(node.arguments)

        type =
          node.type.try do |item|
            ": #{workspace.formatter.format(item)}"
          end

        [
          "**#{name}.#{node.name.value}#{arguments}#{type}**\n",
          node.comment.try(&.value.strip),
        ].compact
      end
    end
  end
end
