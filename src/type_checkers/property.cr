module Mint
  class TypeChecker
    def static_type_signature(node : Ast::Property) : Checkable
      node.type.try { |type| resolve type } || Variable.new("a")
    end

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

          error :property_type_mismatch do
            block do
              text "The type of the default value of the"
              bold node.name.value
              text "property does not match its type annotation."
            end

            expected type, default
            snippet node
          end unless resolved

          resolved
        when {Checkable, Nil}
          default
        when {Nil, Checkable}
          type
        else
          error :property_type_or_default_needed do
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

      error :property_with_type_variables do
        block "A properties type contains type variables."
        block "Type variables in properties are not allow at this time."

        snippet "The type is:", final
        snippet node
      end if final.have_holes?

      final
    end
  end
end
