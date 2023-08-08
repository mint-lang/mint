module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::ConnectVariable, workspace : Workspace, stack : Array(Ast::Node))
        return unless cursor_intersects?(node.name)

        return unless connect = stack[1]?.as?(Ast::Connect)

        return unless store =
                        workspace.ast.stores.find(&.name.value.==(connect.store.value))

        return unless target = store.functions.find(&.name.value.==(node.name.value)) ||
                               store.constants.find(&.name.value.==(node.name.value)) ||
                               store.states.find(&.name.value.==(node.name.value)) ||
                               store.gets.find(&.name.value.==(node.name.value))

        case target
        when Ast::Function, Ast::State, Ast::Get, Ast::Constant
          location_link node.name, target.name, target
        end
      end
    end
  end
end
