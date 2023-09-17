module Mint
  class Compiler
    def _compile(node : Ast::LocaleKey) : String
      %(_L.t("#{node.value}"))
    end
  end
end
