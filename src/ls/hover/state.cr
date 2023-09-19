module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::State, workspace) : Array(String)
        default =
          " = #{workspace.formatter.format(node.default)}"

        type =
          node.type.try do |item|
            " : #{workspace.formatter.format(item)}"
          end

        [
          "**#{node.name.value}#{type}#{default}**\n",
          node.comment.try(&.content.strip),
        ].compact
      end
    end
  end
end
