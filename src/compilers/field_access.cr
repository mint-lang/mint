module Mint
  class Compiler
    def compile(node : Ast::FieldAccess) : Compiled
      compile node do
        js.call(Builtin::Access, [js.string(node.name.value)])
      end
    end
  end
end
