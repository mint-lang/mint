module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::Type,
        workspace : FileWorkspace,
        type_checker : TypeChecker
      ) : Array(String)
        definition =
          type_checker
            .artifacts
            .ast
            .type_definitions
            .find(&.name.value.==(node.name.value))

        if definition
          hover(definition, workspace, type_checker)
        else
          type =
            workspace.format(node)

          ["```\n#{type}\n```"]
        end
      end
    end
  end
end
