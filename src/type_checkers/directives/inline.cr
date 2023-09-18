module Mint
  class TypeChecker
    def check(node : Ast::Directives::Inline) : Checkable
      error! :inline_directive_expected_file do
        block "The path specified for an inline directive does not exist:"

        if ENV["SPEC"]?
          snippet node.path.to_s
        else
          snippet node.real_path.to_s
        end

        snippet "The inline directive in question is here:", node
      end unless node.exists?

      STRING
    end
  end
end
