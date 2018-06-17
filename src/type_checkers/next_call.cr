module Mint
  class TypeChecker
    type_error NextCallInvalidInvokation
    type_error NextCallTypeMismatch

    def check(node : Ast::NextCall) : Checkable
      type =
        resolve node.data

      state =
        scope.find("state")

      raise NextCallInvalidInvokation, {
        "node" => node,
      } unless state

      state_type =
        resolve state

      raise NextCallTypeMismatch, {
        "expected" => state_type,
        "got"      => type,
        "node"     => node,
      } unless Comparer.compare(state_type, type)

      VOID
    end
  end
end
