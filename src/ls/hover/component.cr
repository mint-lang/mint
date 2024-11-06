module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::Component,
        workspace : Workspace,
        type_checker : TypeChecker
      ) : Array(String)
        properties =
          node
            .properties
            .flat_map { |property| hover(property, workspace, type_checker) }

        properties_title =
          "\n**Properties**\n" unless properties.empty?

        ([
          "**#{node.name.value}**\n",
          node.comment.try(&.content.strip),
          properties_title,
        ] + properties).compact
      end
    end
  end
end
