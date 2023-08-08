module Mint
  class TypeChecker
    def check(node : Ast::StringLiteral) : Checkable
      node.value.each do |item|
        case item
        when Ast::Node
          item_type =
            resolve item

          error! :string_literal_interpolation_type_mismatch do
            snippet "An interpolation in string is causing a mismatch. " \
                    "The expected type is:", STRING
            snippet "Instead it is:", item_type
            snippet "The interpolation in question is here:", item
          end unless Comparer.matches_any?(item_type, [STRING, NUMBER])
        end
      end

      STRING
    end
  end
end
