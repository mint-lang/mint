module Mint
  class Compiler2
    def compile(node : Ast::MemberAccess) : Compiled
      js.call(Builtin::Access, [[%("#{node.name.value}")] of Item])
    end
  end
end
