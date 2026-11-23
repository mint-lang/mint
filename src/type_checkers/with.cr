module Mint
  class TypeChecker
    def check(node : Ast::WithItem) : Checkable
      type =
        resolve node.type

      error! :with_type_variable do
        snippet "The type of a value cannot have type variables:", type
        snippet "The value in question is here:", node
      end if type.have_holes?

      type
    end

    def check(node : Ast::With) : Checkable
      resolve node.items
      resolve node.body
    end
  end
end
