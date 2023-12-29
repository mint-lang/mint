module Mint
  class Compiler2
    def compile(node : Ast::Directives::Asset) : Compiled
      compile node do
        prefix =
          config.relative ? "" : "/"

        [
          "`#{prefix}#{ASSET_DIR}/#{node.filename(build: config.build)}`",
        ] of Item
      end
    end
  end
end
