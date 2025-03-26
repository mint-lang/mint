module Mint
  class TypeChecker
    def check(node : Ast::Encode) : Checkable
      expression =
        case item = node.expression
        when Ast::Record
          resolve item, true
        else
          resolve item
        end

      error! :encode_complex_type do
        snippet "This type cannot be automatically encoded:", expression
        snippet "The encode in question is here:", node
      end unless check_decode(expression)

      OBJECT
    end
  end
end
