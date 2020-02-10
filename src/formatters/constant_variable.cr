module Mint
  class Formatter
    def format(node : Ast::ConstantVariable) : String
      format node.name
    end
  end
end
