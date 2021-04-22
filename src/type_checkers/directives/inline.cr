module Mint
  class TypeChecker
    type_error AssetDirectiveExpectedFile

    def check(node : Ast::Directives::Inline) : Checkable
      raise AssetDirectiveExpectedFile, {
        "path" => node.real_path.to_s,
        "node" => node,
      } unless node.exists?

      # puts File.new(node.real_path).encoding

      STRING
    end
  end
end
