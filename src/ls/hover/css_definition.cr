module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::CssDefinition,
        workspace : FileWorkspace,
        type_checker : TypeChecker
      ) : Array(String)
        path =
          URI.encode_path(node.name)

        [
          "CSS Property - **#{node.name}**",
          "[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/CSS/#{path})",
        ]
      end
    end
  end
end
