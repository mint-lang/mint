module Mint
  class Compiler2
    def compile(node : Ast::LocaleKey) : Compiled
      js.call(Builtin::Translate, [[%("#{node.value}")] of Item])
    end
  end
end
