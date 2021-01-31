module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::Property, workspace) : Array(String)
        default =
          node.default.try do |item|
            " = #{workspace.formatter.format(item)}"
          end

        type =
          node.type.try do |item|
            " : #{workspace.formatter.format(item)}"
          end

        [
          "**#{node.name.value}#{type}#{default}**\n",
          node.comment.try(&.value.strip),
        ].compact
      end
    end
  end
end
