module Mint
  class Formatter
    def format(node : Ast::Block) : String
      list node.statements
    end
  end
end
