module Mint
  class Formatter
    def format(node : Ast::Discard) : String
      "_"
    end
  end
end
