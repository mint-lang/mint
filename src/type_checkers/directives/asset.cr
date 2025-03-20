module Mint
  class TypeChecker
    def check(node : Ast::Directives::Asset) : Checkable
      error! :asset_directive_expected_file do
        snippet "The path specified for an asset directive does not exist:", node.relative_path_posix
        snippet "The asset directive in question is here:", node
      end unless node.exists?

      assets << node if checking?
      STRING
    end
  end
end
