module Mint
  class Formatter
    def format(node : Ast::TypeVariable) : String
      node.value
    end
  end
end
