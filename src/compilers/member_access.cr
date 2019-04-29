module Mint
  class Compiler
    def _compile(node : Ast::MemberAccess) : String
      "((_) => _.#{node.name.value})"
    end
  end
end
