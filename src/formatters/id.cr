module Mint
  class Formatter
    def format(node : Ast::Id) : String
      node.value
    end
  end
end
