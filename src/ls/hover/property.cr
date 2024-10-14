module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::Property,
        workspace : Workspace,
        type_checker : TypeChecker
      ) : Array(String)
        default =
          node.default.try do |item|
            " = #{workspace.format(item)}"
          end

        type =
          node.type.try do |item|
            " : #{workspace.format(item)}"
          end

        [
          "**#{node.name.value}#{type}#{default}**\n",
          node.comment.try(&.content.strip),
        ].compact
      end
    end
  end
end
