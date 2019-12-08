module Mint
  class TypeChecker
    def check(node : Ast::RecordField, should_create_record : Bool = false) : Checkable
      case exprssion = node.value
      when Ast::Record
        resolve exprssion, should_create_record
      else
        resolve exprssion
      end
    end
  end
end
