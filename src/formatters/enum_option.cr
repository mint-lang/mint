module Mint
  class Formatter
    def format(node : Ast::EnumOption)
      node.value
    end
  end
end
