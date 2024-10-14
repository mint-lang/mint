module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::Get,
        workspace : Workspace,
        type_checker : TypeChecker
      ) : Array(String)
        ast =
          type_checker.artifacts.ast

        entity =
          ast.components.find(&.gets.includes?(node)) ||
            ast.stores.find(&.gets.includes?(node))

        name =
          case entity
          when Ast::Component, Ast::Store
            entity.name.value
          end

        type =
          node.type.try do |item|
            ": #{workspace.format(item)}"
          end

        [
          "**#{name}.#{node.name.value}#{type}**\n",
          node.comment.try(&.content.strip),
        ].compact
      end
    end
  end
end
