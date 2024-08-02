module Mint
  class Compiler
    def compile(node : Ast::LocaleKey) : Compiled
      compile node do
        js.call(Builtin::Translate, [js.string(node.value)])
      end
    end
  end
end
