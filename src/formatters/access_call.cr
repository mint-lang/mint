module Mint
  class Formatter
    def format(node : Ast::AccessCall) : String
      access =
        format node.access

      format access, node
    end
  end
end
