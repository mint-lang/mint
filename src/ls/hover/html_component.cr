module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::HtmlComponent,
        workspace : Workspace,
        type_checker : TypeChecker,
      ) : Array(String)
        component =
          type_checker.lookups[node]?.try(&.first?)

        hover(component, workspace, type_checker)
      end
    end
  end
end
