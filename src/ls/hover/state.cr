module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::State,
        workspace : FileWorkspace,
        type_checker : TypeChecker
      ) : Array(String)
        default =
          " = #{workspace.format(node.default)}"

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
