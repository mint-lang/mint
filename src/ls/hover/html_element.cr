module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::HtmlElement, workspace) : Array(String?)
        [
          "**#{node.tag.value}**\n",
          "[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/#{node.tag.value})",
        ] of String?
      end
    end
  end
end
