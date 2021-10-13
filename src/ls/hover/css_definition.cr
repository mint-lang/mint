module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::CssDefinition, workspace) : Array(String)
        path =
          {% if compare_versions(Crystal::VERSION, "1.1.1") <= 0 %}
            URI.encode(node.name, space_to_plus: true)
          {% else %}
            URI.encode_path(node.name)
          {% end %}

        [
          "CSS Property - **#{node.name}**",
          "[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/CSS/#{path})",
        ]
      end
    end
  end
end
