module Mint
  class Compiler
    def _compile(node : Ast::Directives::Inline) : Codegen::Node
      # skip { "`#{node.file_contents}`" }
      ""
    end
  end
end
