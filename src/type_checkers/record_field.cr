module Mint
  class TypeChecker
    def check(node : Ast::RecordField, should_create_record : Bool = false) : Checkable
      case expression = node.value
      when Ast::Record
        resolve expression, should_create_record
      else
        resolve expression
      end
    end
  end
end
