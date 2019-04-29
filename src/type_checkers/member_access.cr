module Mint
  class TypeChecker
    def check(node : Ast::MemberAccess) : Checkable
      variable =
        Variable.new("a")

      access =
        PartialRecord.new("", {node.name.value => variable} of String => Checkable)

      Type.new("Function", [access, variable] of Checkable)
    end
  end
end
