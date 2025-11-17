module Mint
  class TypeChecker
    def check(node : Ast::State) : Checkable
      default =
        with_restricted_top_level_entity(node) do
          resolve node.default
        end

      if item = node.type
        type =
          resolve item

        resolved =
          Comparer.compare type, default, expand: true

        error! :state_type_mismatch do
          snippet "The type of the default value of the a state does " \
                  "not match its type annotation:", node.default

          expected type, default
        end unless resolved

        resolved
      else
        default
      end
    end
  end
end
