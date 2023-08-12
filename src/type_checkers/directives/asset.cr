module Mint
  class TypeChecker
    def check(node : Ast::Directives::Asset) : Checkable
      error :asset_directive_expected_file do
        block "The path specified for an asset directive does not exists."

        block do
          text "The file should be here: "
          bold node.real_path.to_s
        end

        snippet node
      end unless node.exists?

      assets << node if checking?
      STRING
    end
  end
end
