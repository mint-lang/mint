module Mint
  class Formatter
    def format(node : Ast::LocaleKey) : String
      ":#{node.value}"
    end
  end
end
