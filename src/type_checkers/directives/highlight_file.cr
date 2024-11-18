module Mint
  class TypeChecker
    def check(node : Ast::Directives::HighlightFile) : Checkable
      error! :highlight_file_directive_expected_file do
        snippet "The path specified for an highlight file directive does not exist:", node.relative_path
        snippet "The highlight file directive in question is here:", node
      end unless node.exists?

      HTML
    end
  end
end
