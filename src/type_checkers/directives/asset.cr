module Mint
  class TypeChecker
    type_error AssetDirectiveExpectedFile

    def check(node : Ast::Directives::Asset) : Checkable
      raise AssetDirectiveExpectedFile, {
        "path" => node.real_path.to_s,
        "node" => node,
      } unless node.exists?

      assets << node
      STRING
    end
  end
end
