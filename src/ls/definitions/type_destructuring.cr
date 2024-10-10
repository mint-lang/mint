module Mint
  module LS
    class Definitions
      def definition(node : Ast::TypeDestructuring)
        if item = @type_checker.lookups[node]?
          variant, definition = item

          case {variant, definition}
          when {Ast::TypeVariant, Ast::TypeDefinition}
            location_link node, variant.value, variant
          end
        end
      end
    end
  end
end
