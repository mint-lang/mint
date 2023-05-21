module Mint
  class TypeChecker
    type_error ReturnCallInvalid

    def check(node : Ast::ReturnCall) : Checkable
      raise ReturnCallInvalid, {
        "node" => node,
      } unless node.statement

      type =
        resolve node.expression

      push_return(node)

      type
    end
  end
end
