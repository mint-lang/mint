module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::TypeDefinition,
        workspace : Workspace,
        type_checker : TypeChecker
      ) : Array(String)
        parameters =
          "" # workspace.formatter.format_parameters(node.parameters)

        case items = node.fields
        when Array(Ast::TypeVariant)
          fields = items.map do |option|
            comment =
              option.comment.try { |item| " - #{item.content.strip}" }

            params =
              "" # workspace.formatter.format_parameters(option.parameters)

            "**#{option.value.value}#{params}**#{comment}"
          end

          ([
            "**#{node.name.value}#{parameters}**\n",
            node.comment.try(&.content.strip.+("\n")),
          ] + fields).compact
        else
          type =
            workspace.format(node)

          ["```\n#{type}\n```"]
        end
      end
    end
  end
end
