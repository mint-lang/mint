module Mint
  class Compiler
    def _compile(node : Ast::Directives::Asset) : String
      prefix =
        if relative
          ""
        else
          "/"
        end

      "`#{prefix}#{ASSET_DIR}/#{node.filename}`"
    end
  end
end
