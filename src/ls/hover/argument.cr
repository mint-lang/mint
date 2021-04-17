module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::Argument, workspace) : Array(String)
        type =
          workspace.formatter.format(node.type)

        ["**#{node.name.value} : #{type}**"]
      end
    end
  end
end
