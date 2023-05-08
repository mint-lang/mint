module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::Component, workspace) : Array(String)
        properties =
          node
            .properties
            .flat_map { |property| hover(property, workspace) }

        properties_title =
          "\n**Properties**\n" unless properties.empty?

        ([
          "**#{node.name.value}**\n",
          node.comment.try(&.value.strip),
          properties_title,
        ] + properties).compact
      end
    end

    class Hover < LSP::RequestMessage
      def hover(node : Ast::HtmlComponent, workspace) : Array(String)
        component =
          workspace
            .type_checker
            .lookups[node]?

        hover(component, workspace)
      end
    end
  end
end
