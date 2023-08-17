module Mint
  class TypeChecker
    def check(node : Ast::ReturnCall) : Checkable
      error :return_call_invalid do
        block do
          text "A"
          bold "return call "
          text "can only appear in a block as part of an or operation while destructuring or as a standalone expression."
        end

        snippet node
      end unless node.statement

      type =
        resolve node.expression

      push_return(node)

      type
    end
  end
end
