module Mint
  class Formatter
    def format(node : Ast::Access) : String
      format node.fields, "."
    end
  end
end
