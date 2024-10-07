module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::HtmlElement,
        workspace : FileWorkspace,
        type_checker : TypeChecker
      ) : Array(String)
        path =
          URI.encode_path(node.tag.value)

        [
          "**#{node.tag.value}**\n",
          "[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/#{path})",
        ]
      end
    end
  end
end
