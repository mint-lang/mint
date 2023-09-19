module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::TypeVariant, workspace) : Array(String)
        item =
          workspace
            .ast
            .type_definitions
            .find do |definition|
              case fields = definition.fields
              when Array(Ast::TypeVariant)
                fields.includes?(node)
              end
            end

        hover(item, workspace)
      end
    end
  end
end
