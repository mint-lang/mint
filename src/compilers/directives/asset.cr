module Mint
  class Compiler
    def compile(node : Ast::Directives::Asset) : Compiled
      compile node do
        [Asset.new(node)] of Item
      end
    end
  end
end
