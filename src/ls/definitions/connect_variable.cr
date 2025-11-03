module Mint
  module LS
    class Definitions
      def definition(node : Ast::ConnectVariable)
        return unless cursor_intersects?(node.name)

        return unless connect =
                        @stack[1]?.as?(Ast::Connect)

        return unless store =
                        @type_checker.artifacts.ast.unified_modules.find(&.name.value.==(connect.store.value)) ||
                        @type_checker.artifacts.ast.providers.find(&.name.value.==(connect.store.value)) ||
                        @type_checker.artifacts.ast.stores.find(&.name.value.==(connect.store.value))

        return unless target =
                        @type_checker.artifacts.scope.resolve(node.name.value, store).try(&.node)

        case target
        when Ast::Function, Ast::State, Ast::Get, Ast::Constant
          location_link node.name, target.name, target
        end
      end
    end
  end
end
