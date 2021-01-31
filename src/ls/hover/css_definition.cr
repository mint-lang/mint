module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::CssDefinition, workspace) : Array(String)
        [
          "CSS Property - **#{node.name}**",
          "[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/CSS/#{URI.encode(node.name, space_to_plus: true)})",
        ]
      end
    end
  end
end
