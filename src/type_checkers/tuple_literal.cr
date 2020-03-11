module Mint
  class TypeChecker
    type_error ArrayNotMatches

    def check(node : Ast::TupleLiteral) : Checkable
      items =
        resolve node.items

      Type.new("Tuple", items)
    end
  end
end
