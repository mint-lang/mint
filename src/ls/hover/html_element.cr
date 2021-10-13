module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::HtmlElement, workspace) : Array(String)
        path =
          {% if compare_versions(Crystal::VERSION, "1.1.1") <= 0 %}
            URI.encode(node.tag.value, space_to_plus: true)
          {% else %}
            URI.encode_path(node.tag.value)
          {% end %}

        [
          "**#{node.tag.value}**\n",
          "[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/#{path})",
        ]
      end
    end
  end
end
