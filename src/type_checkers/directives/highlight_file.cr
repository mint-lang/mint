module Mint
  class TypeChecker
    def check(node : Ast::Directives::HighlightFile) : Checkable
      error! :highlight_file_directive_expected_file do
        block "The path specified for an highlight file directive does not exist: "

        if ENV["SPEC"]?
          snippet node.path.to_s
        else
          snippet node.real_path.to_s
        end

        snippet "The highlight file directive in question is here:", node
      end unless node.exists?

      HTML
    end
  end
end
