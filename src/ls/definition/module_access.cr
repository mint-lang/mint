module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::ModuleAccess, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        lookup = workspace.type_checker.lookups[node.variable]?

        if lookup
          case lookup
          when Ast::Property,
               Ast::Constant,
               Ast::Function,
               Ast::State,
               Ast::Get
            location_link server, node.variable, lookup.name, lookup
          end
        end
      end
    end
  end
end
