module Mint
  class Compiler2
    def compile(node : Ast::Directives::Asset) : Compiled
      compile node do
        prefix =
          config.relative ? "" : "/"

        filename =
          node.filename(build: config.build)

        ["`#{prefix}#{ASSET_DIR}/#{filename}`"] of Item
      end
    end
  end
end
