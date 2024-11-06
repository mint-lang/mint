module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::Statement,
        workspace : Workspace,
        type_checker : TypeChecker
      ) : Array(String)
        type =
          type_of(node, type_checker)

        head =
          node.target.try do |target|
            formatted =
              workspace.format(target)

            "**#{formatted} =**"
          end

        [
          head,
          type,
        ].compact
      end
    end
  end
end
