module Mint
  class TypeChecker
    type_error InlineDirectiveExpectedFile

    def check(node : Ast::Directives::Inline) : Checkable
      raise InlineDirectiveExpectedFile, {
        "path" => node.real_path.to_s,
        "node" => node,
      } unless node.exists?

      STRING
    end
  end
end
