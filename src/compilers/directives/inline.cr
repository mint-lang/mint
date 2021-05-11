module Mint
  class Compiler
    def _compile(node : Ast::Directives::Inline) : String
      skip { "`#{node.file_contents}`" }
    end
  end
end
