module Mint
  class Compiler
    def _compile(node : Ast::Directives::Asset) : Codegen::Node
      prefix =
        relative ? "" : "/"

      "`#{prefix}#{ASSET_DIR}/#{node.filename(build: @build)}`"
    end
  end
end
