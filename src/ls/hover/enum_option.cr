module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::EnumOption, workspace) : Array(String?)
        item =
          workspace.ast.enums.find(&.options.includes?(node))

        hover(item, workspace)
      end
    end
  end
end
