module Mint
  class Compiler
    def _compile(node : Ast::ArrayAccess) : String
      "_at(#{compile node.lhs}, #{node.index})"
    end
  end
end
