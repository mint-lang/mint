module Mint
  class Compiler2
    def compile(node : Ast::LocaleKey) : Compiled
      compile node do
        js.call(Builtin::Translate, [js.string(node.value)])
      end
    end
  end
end
