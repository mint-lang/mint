module Mint
  class Compiler
    def _compile(node : Ast::Directives::Inline) : String
      skip { "`#{File.read(node.real_path)}`" }
    end
  end
end
