module Mint
  class Compiler
    def _compile(node : Ast::Directives::Asset) : String
      "`/assets/#{node.filename}`"
    end
  end
end
