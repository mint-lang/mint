module Mint
  class Compiler
    def _compile(node : Ast::Js) : String
      node.value.strip
    end
  end
end
