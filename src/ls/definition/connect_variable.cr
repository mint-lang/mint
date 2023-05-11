module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::ConnectVariable, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        return unless cursor_intersects?(node.variable)

        return unless connect = stack[1]?.as?(Ast::Connect)

        return unless store =
                        workspace.ast.stores.find(&.name.value.==(connect.store.value))

        return unless target = store.functions.find(&.name.value.==(node.variable.value)) ||
                               store.constants.find(&.name.value.==(node.variable.value)) ||
                               store.states.find(&.name.value.==(node.variable.value)) ||
                               store.gets.find(&.name.value.==(node.variable.value))

        case target
        when Ast::Function, Ast::State, Ast::Get, Ast::Constant
          location_link server, node.variable, target.name, target
        end
      end
    end
  end
end
