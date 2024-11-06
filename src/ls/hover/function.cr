module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::Function,
        workspace : Workspace,
        type_checker : TypeChecker
      ) : Array(String)
        ast =
          type_checker.artifacts.ast

        entity =
          ast.unified_modules.find(&.functions.includes?(node)) ||
            ast.components.find(&.functions.includes?(node)) ||
            ast.providers.find(&.functions.includes?(node)) ||
            ast.stores.find(&.functions.includes?(node))

        name =
          case entity
          when Ast::Module, Ast::Component, Ast::Provider, Ast::Store
            entity.name.value
          end

        arguments =
          "" # workspace.formatter.format_arguments(node.arguments)

        type =
          node.type.try do |item|
            ": #{workspace.format(item)}"
          end

        [
          "**#{name}.#{node.name.value}#{arguments}#{type}**\n",
          node.comment.try(&.content.strip),
        ].compact
      end
    end
  end
end
