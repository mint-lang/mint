module Mint
  class TypeChecker
    def check(node : Ast::Field, should_create_record : Bool = false) : Checkable
      case expression = node.value
      when Ast::Record
        resolve expression, should_create_record
      else
        resolve expression
      end.dup.tap do |item|
        item.label = node.key.try(&.value)
      end
    end
  end
end
