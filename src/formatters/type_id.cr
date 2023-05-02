module Mint
  class Formatter
    def format(node : Ast::TypeId) : String
      node.value
    end
  end
end
