module Mint
  class TypeChecker
    def check(node : Ast::Property) : Checkable
      default =
        with_restricted_top_level_entity(node) do
          node.default.try do |item|
            resolve item
          end
        end

      type =
        node.type.try do |item|
          resolve item
        end

      final =
        case {default, type}
        when {Checkable, Checkable}
          resolved =
            Comparer.compare type, default

          error! :property_type_mismatch do
            block "The type of the default value of a property does not " \
                  "match its type annotation."

            expected type, default
            snippet "The property in question is here:", node
          end unless resolved

          resolved
        when {Checkable, Nil}
          default
        when {Nil, Checkable}
          type
        else
          error! :property_type_or_default_needed do
            block do
              text "The"
              bold "type"
              text "or"
              bold "default value"
              text "of a property needs to be defined, but neither was."
            end

            snippet node
          end
        end

      error! :property_with_type_variables do
        block "The type of a property contains type variables. Type " \
              "variables in properties are not allow at this time since " \
              "that would make the compoennt generic and it is not " \
              "supported this time."

        snippet "The type is:", final
        snippet "The property in question is here:", node
      end if final.have_holes?

      final
    end
  end
end
