module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::Type, workspace) : Array(String)
        definition =
          workspace
            .ast
            .type_definitions
            .find(&.name.value.==(node.name.value))

        if definition
          hover(definition, workspace)
        else
          type =
            workspace.formatter.format(node)

          ["```\n#{type}\n```"]
        end
      end
    end
  end
end
