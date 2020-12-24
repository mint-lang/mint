module Mint
  class Compiler
    def _compile(node : Ast::MemberAccess) : Codegen::Node
      "((_) => _.#{node.name.value})"
    end
  end
end
