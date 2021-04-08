module Mint
  class Compiler
    def _compile(node : Ast::Directives::Asset) : String
      "`/#{ASSET_DIR}/#{node.filename}`"
    end
  end
end
