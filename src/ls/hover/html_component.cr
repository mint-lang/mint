module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::Component, workspace) : Array(String?)
        properties =
          node
            .properties
            .flat_map { |property| hover(property, workspace) }

        properties_title =
          unless properties.empty?
            "\n**Properties**\n"
          end

        [
          "**#{node.name}**\n",
          node.comment.try(&.value.strip),
          properties_title,
        ] + properties
      end
    end

    class Hover < LSP::RequestMessage
      def hover(node : Ast::HtmlComponent, workspace) : Array(String?)
        component =
          workspace
            .type_checker
            .lookups[node]?

        hover(component, workspace)
      end
    end
  end
end
