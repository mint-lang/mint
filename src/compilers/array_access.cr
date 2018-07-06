module Mint
  class Compiler
    def compile(node : Ast::ArrayAccess) : String
      "#{compile node.lhs}[#{node.index}]"
    end
  end
end
