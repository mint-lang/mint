module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::TypeVariant,
        workspace : Workspace,
        type_checker : TypeChecker
      ) : Array(String)
        item =
          type_checker
            .artifacts
            .ast
            .type_definitions
            .find do |definition|
              case fields = definition.fields
              when Array(Ast::TypeVariant)
                fields.includes?(node)
              end
            end

        hover(item, workspace, type_checker)
      end
    end
  end
end
