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
          when Ast::Module, Ast::Component, Ast::Provider, Ast::Store
            entity.name.value
          end

        arguments =
          workspace.formatter.format_arguments(node.arguments)

        type =
          node.type.try do |item|
            ": #{workspace.formatter.format(item)}"
          end

        [
          "**#{name}.#{node.name.value}#{arguments}#{type}**\n",
          node.comment.try(&.content.strip),
        ].compact
      end
    end
  end
end
