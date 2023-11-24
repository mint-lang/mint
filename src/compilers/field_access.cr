module Mint
  class Compiler
    def _compile(node : Ast::FieldAccess) : String
      "((_) => _.#{node.name.value})"
    end
  end
end
