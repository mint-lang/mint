module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::Access, workspace) : Array(String)
        if item = workspace.type_checker.variables[node]?
          case item[1]
          when Ast::TypeDefinition
            hover(item[1], workspace)
          end
        end || [] of String
      end
    end
  end
end
