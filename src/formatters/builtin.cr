module Mint
  class Formatter
    def format(node : Ast::Builtin) : String
      "%#{node.value}%"
    end
  end
end
