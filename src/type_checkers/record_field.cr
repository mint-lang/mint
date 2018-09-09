module Mint
  class TypeChecker
    def check(node : Ast::RecordField, for_checking : Bool) : Checkable
      value =
        node.value

      case value
      when Ast::Record
        resolve value, for_checking
      else
        resolve value
      end
    end
  end
end
