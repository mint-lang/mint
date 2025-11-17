module Mint
  class TypeChecker
    def check(node : Ast::Signal) : Checkable
      block =
        with_restricted_top_level_entity(node) do
          resolve node.block
        end

      type =
        resolve node.type

      error! :signal_type_mismatch do
        block "The return type of the block of the a signal does " \
              "not match the signals type annotation."

        expected type, block

        snippet "The block in question is here:", node.block
      end unless resolved = Comparer.compare(type, block, expand: true)

      resolved
    end
  end
end
