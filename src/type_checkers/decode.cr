module Mint
  class TypeChecker
    def check(node : Ast::Decode) : Type
      expression =
        check node.expression

      type =
        check node.type

      puts expression, type

      raise "" unless type

      types[node] = type

      Type.new("Result", [Type.new("Object.Error"), type])
    end
  end
end
