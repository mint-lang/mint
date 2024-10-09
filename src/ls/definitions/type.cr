module Mint
  module LS
    class Definitions
      def definition(node : Ast::Type)
        return unless cursor_intersects?(node.name)

        return unless record =
                        @type_checker.artifacts.ast.type_definitions
                          .find(&.name.value.==(node.name.value))

        return if Core.ast.type_definitions.includes?(record)

        location_link node.name, record.name, record
      end
    end
  end
end
