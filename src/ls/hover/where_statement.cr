module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::WhereStatement, workspace) : Array(String?)
        type =
          workspace
            .type_checker
            .cache[node]?
            .try(&.to_pretty)
            .try { |value| "```\n#{value}\n```" }

        head =
          workspace
            .formatter
            .format(node.target)

        [
          "**#{head} =**",
          type,
        ] of String?
      end
    end
  end
end
