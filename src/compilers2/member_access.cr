module Mint
  class Compiler2
    def compile(node : Ast::MemberAccess) : Compiled
      compile node do
        js.call(Builtin::Access, [js.string(node.name.value)])
      end
    end
  end
end
