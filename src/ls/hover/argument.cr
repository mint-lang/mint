module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::Argument,
        workspace : FileWorkspace,
        type_checker : TypeChecker
      ) : Array(String)
        type =
          workspace.format(node.type)

        ["**#{node.name.value} : #{type}**"]
      end
    end
  end
end
