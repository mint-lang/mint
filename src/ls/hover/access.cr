module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::Access,
        workspace : Workspace,
        type_checker : TypeChecker
      ) : Array(String)
        if item = type_checker.variables[node]?
          case item[1]
          when Ast::TypeDefinition
            hover(item[1], workspace, type_checker)
          end
        end || [] of String
      end
    end
  end
end
