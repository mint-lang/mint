module Mint
  module LS
    class Definitions
      def definition(node : Ast::Access)
        lookup =
          @type_checker.variables[node]?.try(&.first)

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
