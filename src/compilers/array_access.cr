module Mint
  class Compiler
    def compile(node : Ast::ArrayAccess) : String
      "_at(#{compile node.lhs}, #{node.index})"
    end
  end
end
