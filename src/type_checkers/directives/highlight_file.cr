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

      contents =
        File.read(node.real_path)

      parser = Parser.new(contents, node.real_path.to_s)
      parser.parse
      parser.eof!

      error! :highlight_file_directive_expected_mint do
        block "I was expecting a Mint file for a highlight file directive " \
              "but I could not parse it."

        snippet(
          "These are the first few lines of the file:",
          contents.lines[0..4].join("\n"))

        snippet "The highlight file directive in question is here:", node
      end unless parser.errors.empty?

      HTML
    end
  end
end
