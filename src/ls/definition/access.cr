module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::Access, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        lookup = workspace.type_checker.variables[node]?.try(&.first)

        if lookup
          case lookup
          when Ast::Property,
               Ast::Constant,
               Ast::Function,
               Ast::State,
               Ast::Get
            location_link node.field, lookup.name, lookup
          end
        end
      end
    end
  end
end
